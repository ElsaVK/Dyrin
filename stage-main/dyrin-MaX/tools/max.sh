#!/bin/bash
MAX_VERSION=1.0.0
#get the last gitlab project release number
last_gitlab_project_release(){
  basename $(curl -fs -o/dev/null -w %{redirect_url} $1)
}

display_usage(){
    echo ""
    echo ""
    echo "   -h: Display help."
    echo "   -p: Specify BaseX port to use for db feed. Default one is "$PORT"."
    echo "   -i: Max initialization."
    echo "   -n: Deploy new edition with its XML sources."
    echo "   --d-tei: Deploy the TEI demo edition project."
    echo "   --d-ead: Deploy the EAD demo edition project."
    echo "   --list-plugins: Show plugins and status."
    echo "   --enable-plugin [plugin_name]: Enable [plugin_name] plugin."
    echo "   --disable-plugin [plugin_name]: Disable [plugin_name] plugin."
    echo ""
}

PORT=1984
DIRECTORY=$(cd `dirname $0` && pwd)

#read max version in package.json(dev mode) file or VERSION file (prod mode)
if [ ! -f $DIRECTORY'/../VERSION' ]
then
  MAX_VERSION=$(node -p -e "require('$DIRECTORY/../package.json').version")'-dev'
else
  MAX_VERSION=`cat $DIRECTORY'/../VERSION'`
fi

MAX_PLUGINS_DIR=$DIRECTORY/../plugins
BASEX_CLIENT_BIN="basexclient"
BASEX_BIN="basex"
TEI_DEMO_URL="https://git.unicaen.fr/pdn-certic/max-tei-demo"
EAD_DEMO_URL="https://git.unicaen.fr/pdn-certic/max-ead-demo"
MAX_TEI_DEMO_VERSION_NUMBER=`last_gitlab_project_release $TEI_DEMO_URL'/-/releases/permalink/latest'`
if [ $? -gt 0 ]
  then
    display_usage
    echo ''
    echo 'MaX : Cannot access to remote url - please check your network configuration.'
    exit 1
fi
MAX_EAD_DEMO_VERSION_NUMBER=`last_gitlab_project_release $EAD_DEMO_URL'/-/releases/permalink/latest'`
MAX_TEI_DEMO_VERSION="max-tei-demo-"$MAX_TEI_DEMO_VERSION_NUMBER
MAX_EAD_DEMO_VERSION="max-ead-demo-"$MAX_EAD_DEMO_VERSION_NUMBER
TEI_DEMO_RELEASE_URL=$TEI_DEMO_URL"/-/archive/"$MAX_TEI_DEMO_VERSION_NUMBER"/"$MAX_TEI_DEMO_VERSION".zip"
EAD_DEMO_RELEASE_URL=$EAD_DEMO_URL"/-/archive/"$MAX_EAD_DEMO_VERSION_NUMBER"/"$MAX_EAD_DEMO_VERSION".zip"
SAXON_HE_URL="https://repo1.maven.org/maven2/net/sf/saxon/Saxon-HE/10.8/Saxon-HE-10.8.jar"
FOP_URL="https://files.basex.org/modules/org/basex/modules/fop/FOP.jar"

DEFAULT_EAD_PLUGINS=(side_toc ead_basket)

dependency_test(){
  result=$(command -v $1)
  if [ -z $result ]
  then
      echo 'Dependency '$1' not satisfied - please install it first'
      exit -1
  else
      echo 'Dependency '$1' satisfied'
  fi
}

install_jar_in_libs(){
  jar_url=$1
  jar_name=`basename $jar_url`
  basex_libs=`which $BASEX_BIN`
  d=`dirname $basex_libs`/../lib
  if [ ! -f $d/$jar_name ]
  then
    echo "Downloading jar "$jar_url
    curl --silent -O $jar_url
    ret_code=$?
    if [ $ret_code -gt 0 ]
    then
        echo 'Cannot install jar '$jar_url
        exit -1
    else
      mv $jar_name $d
    fi
  fi
  echo $jar_name': ok'
}

echo "---------------------------"
echo "  MaX - Utilities - "$MAX_VERSION
echo "---------------------------"

#checks and set basex bin
a=$(command -v basexclient)

if [ -z $a ] && [ -z $BASEX_PATH ]
then
   display_usage
   echo "Please install BaseX or set \$BASEX_PATH environment variable"
   exit 1
else
   if [ -z $a ]
   then
      BASEX_CLIENT_BIN=$BASEX_PATH"/bin/basexclient"
      BASEX_BIN=$BASEX_PATH"/bin/basex"
   fi
fi

echo ""
echo "Environment variable BASEX_PATH = "$BASEX_PATH
echo ""

#checks if fop & saxon he jar are in basex libs
echo ""
install_jar_in_libs $SAXON_HE_URL
install_jar_in_libs $FOP_URL
echo ""


list_plugins(){
  echo -e ''
  echo -e 'MaX plugins : '
#  list_plugins_dir $MAX_PLUGINS_DIR
  for i in `ls $MAX_PLUGINS_DIR`
  do
    COUNT_PLUGIN_USAGE=$($BASEX_BIN "count(doc('../configuration/configuration.xml')//plugin[@name='$i'])")
    echo -e '\n- '$i' :'
    if [ $COUNT_PLUGIN_USAGE -eq 0 ]
    then
      echo -e "\tnot used"
    else
      echo -e "\tenabled in "$COUNT_PLUGIN_USAGE" edition(s)"
    fi
  done
  echo -e ''
}


enable_plugin(){
  echo -e ''
  if [ ! $2 ]
  then
    echo "Usage : max.sh --enable-plugin [plugin_name] [edition_name]: Enable [plugin_name] plugin for edition [edition_name]"
    echo -e ''
    return
  fi
  if [ ! -d $MAX_PLUGINS_DIR/$1 ]
    then
      echo "Oups ! Plugin "$1" does not exist."$MAX_PLUGINS_DIR/$1
      echo -e ''
      return
  fi

  if [ -f $MAX_PLUGINS_DIR/$1/.ignore ]
  then
      rm $MAX_PLUGINS_DIR/$1/.ignore
  fi

  $BASEX_BIN -u -bpluginId=$1 -bprojectId=$2 $DIRECTORY"/xq/insert_plugin_config.xq" # -u => save modified file on disk

  if [ $? -eq 0 ]
  then
    echo -e "Plugin $1 successfully enabled"
  else
    echo -e "ERROR - Plugin $1 was not enabled !"
  fi
  echo -e ''
}

disable_plugin(){
  echo -e ''
  if [ ! $2 ]
  then
    echo "Usage : max.sh --disable-plugin [plugin_name] [edition_name]: disable [plugin_name] plugin for edition [edition_name]"
    echo -e ''
    return
  fi

  $BASEX_BIN -u -bpluginId=$1 -bprojectId=$2 $DIRECTORY"/xq/remove_plugin_config.xq" # -u => save modified file on disk

  NB_USAGE=$($BASEX_BIN "count(doc('$DIRECTORY/../configuration/configuration.xml')//plugin[@name='$1'])")

  if [ $NB_USAGE -eq 0 ]
  then
    touch $MAX_PLUGINS_DIR/$1/.ignore
  fi
  echo -e "Plugin $1 successfully disabled."
  echo -e ''
}


#adds xml datas to a new db
db_project_feed(){
   feed_cmd=$BASEX_CLIENT_BIN" -p$PORT -w -cfeed.txt"
   echo "Please type your BaseX login/password :"
   echo "CREATE DATABASE "$1 > feed.txt
   echo "ADD "$2 >> feed.txt
   eval $feed_cmd
   ret_code=$?
   if [ $ret_code -gt 0 ]
    then echo "Cannot insert data in DB. Is your BaseX running on "$PORT" ?"
    rm feed.txt
    return 1
   else
    echo "INFO: The "$1" DB was successfully created."
    rm feed.txt
    return 0
   fi
}

# install demo sources from its dataset directory
db_demo_feed(){
    edition_name=$1
    db_project_feed $1 $DIRECTORY/../editions/$1/dataset/
    ret_code=$?
    return $ret_code
}

#is project already declared in main config file ?
check_project_xinclude(){
  edition_name=$1
  a=$($BASEX_BIN -bprojectId=$edition_name -bmaxPath=$DIRECTORY/.. $DIRECTORY"/xq/check_config_exists.xq")
  if [ $a == 0 ]
  then
    echo 'Edition '$edition_name' is already declared in configuration file. Remove it before installing your edition.'
    echo 'Installation stopped !'
    return 1
  fi
  return 0
}

# demo edition deployment
install_demo(){
  url=$1
  zip_name=$2
  edition_name=$3
  check_project_xinclude $edition_name
  if [ $? -gt 0 ]
  then
    exit -1
  fi

  if [ ! -d $DIRECTORY/../editions ]
  then
    echo 'Creates "editions" directory.'
    mkdir $DIRECTORY/../editions
  fi

  if [ -d $DIRECTORY/../editions/$edition_name ]
  then
    echo "Removes existing demo edition."
    rm -rf $DIRECTORY/../editions/$edition_name
  fi

  cd $DIRECTORY/../editions
  echo "Downloading Max Demo resources at "$url
  curl --silent -O $url
  unzip $zip_name.zip
  getResult=$?
  if [ $getResult -ne 0 ]
  then
   echo 'MaX demo install error : Cannot fetch '$url
   exit -1
  fi
  mv $zip_name $edition_name
  rm $zip_name.zip
  cd $DIRECTORY

  db_demo_feed $edition_name

  ret_code=$?
  if [ $ret_code -gt 0 ]
    then echo $edition_name": installation failed"
    rm -rf $DIRECTORY/../editions/$edition_name
    return 1
  fi

  #include edition conf file in main max config one
  include_project_config $edition_name

  #get plugins list from config file
  plugin_list=$($BASEX_BIN -q'for $p in doc("../configuration/configuration.xml")//edition[@xml:id="'$edition_name'"]//plugin return string($p/@name)')

  #then install plugins
  for plugin in ${plugin_list[@]}
  do
    enable_plugin $plugin $edition_name
  done


  if [ $? -ne 0 ]
  then
    echo 'Process failed'
    exit 1
  fi

  echo "INFO: The edition "$edition_name" was successfully deployed."
  return 0

}


deploy_new_edition(){
  read -e -p "Project ID ? " project_id
  read -e -p "XML Project type (tei, ead, ...) ? " xmlns
  read -e -p "Database path ? " db_path

  check_project_xinclude $project_id
  if [ $? -gt 0 ]
  then
    exit -1
  fi

  new_edition_build $project_id $db_path $xmlns
  read -e -p "XML sources path ? " data_path
  db_project_feed $db_path $data_path
  ret_code=$?
  if [ $ret_code -gt 0 ]
  then
    echo 'Process failed'
    return -1
  fi

  mkdir -p $DIRECTORY/../editions/$project_id/fragments/fr
  mkdir $DIRECTORY/../editions/$project_id/xq
  mkdir $DIRECTORY/../editions/$project_id/ui
  mkdir $DIRECTORY/../editions/$project_id/ui/css
  mkdir $DIRECTORY/../editions/$project_id/ui/fonts
  mkdir $DIRECTORY/../editions/$project_id/ui/i18n
  mkdir $DIRECTORY/../editions/$project_id/ui/images
  mkdir $DIRECTORY/../editions/$project_id/ui/js
  mkdir $DIRECTORY/../editions/$project_id/ui/templates
  mkdir $DIRECTORY/../editions/$project_id/ui/xsl

  touch $DIRECTORY/../editions/$project_id/ui/css/$project_id.css

  #creates about frag page
  touch $DIRECTORY/../editions/$project_id/fragments/fr/about.frag.html
  echo "<section>" > $DIRECTORY/../editions/$project_id/fragments/fr/about.frag.html
  echo "<h1>À propos</h1>" >> $DIRECTORY/../editions/$project_id/fragments/fr/about.frag.html
  echo "<p>Modifiez moi dans editions/$project_id/fragments/fr/about.frag.html.</p>" >> $DIRECTORY/../editions/$project_id/fragments/fr/about.frag.html
  echo "</section>" >> $DIRECTORY/../editions/$project_id/fragments/fr/about.frag.html
  cp $DIRECTORY/menu_default.xml $DIRECTORY/../editions/$project_id/menu.xml
  if [ $xmlns = 'ead' ]
  then
      for plugin in ${DEFAULT_EAD_PLUGINS[@]}
      do
        enable_plugin $plugin $project_id
      done
  fi
  echo ''
  echo "Project "$project_id" is ready !"
  exit 0
}


include_project_config(){
    $BASEX_BIN -u -bprojectId=$1 $DIRECTORY"/xq/include_project_config.xq" # -u => save modified file on disk
}

new_edition_build(){
  if [ ! -d $DIRECTORY/../editions ]
  then
    echo 'Creates "editions" directory.'
    mkdir $DIRECTORY/../editions
  fi
  mkdir $DIRECTORY/../editions/$1
  $BASEX_BIN -bprojectId=$1 -bdbPath=$2 -benvType=$3 -bmaxPath=$DIRECTORY/.. $DIRECTORY"/xq/create_project_config.xq"
  include_project_config $1
}




init_dev_max(){
  if [ -f $DIRECTORY'/../package.json' ]
  then
    dependency_test npm
    cd $DIRECTORY/..
    npm install
    echo " -> Adds nodes_modules/.ignore file."
    touch $DIRECTORY"/../node_modules/.ignore"
    echo -e "\n disabling all plugins (.ignore file)"
    for i in `ls $MAX_PLUGINS_DIR`
    do
      touch $MAX_PLUGINS_DIR/$i/.ignore
    done

    echo "
      *** MaX initialization is finished :) ***
";
  fi
}



# 1 argument required
if [  $# -lt 1 ]
then
    display_usage
    exit 1
fi


#creates config file if not exists (.dist copy)
if [ ! -f $DIRECTORY/../configuration/configuration.xml ]
then
    echo "Configuration file does not exist: copying the .dist one"
    cp  $DIRECTORY/../configuration/configuration.dist.xml $DIRECTORY/../configuration/configuration.xml
fi


while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h) display_usage
            exit 0;;
        -p) PORT="$2"; shift ;;
        -n) deploy_new_edition;exit 0;;
        -i) init_dev_max;exit 0;;
        --d-tei) install_demo $TEI_DEMO_RELEASE_URL $MAX_TEI_DEMO_VERSION max_tei_demo;exit 0;;
        --d-ead) install_demo $EAD_DEMO_RELEASE_URL $MAX_EAD_DEMO_VERSION max_ead_demo;exit 0;;
        --list-plugins) list_plugins;exit 0;;
        --enable-plugin) enable_plugin $2 $3;exit 0;;
        --disable-plugin) disable_plugin $2 $3;exit 0;;
         *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

