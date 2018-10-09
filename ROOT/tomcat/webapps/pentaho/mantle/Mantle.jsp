<%--
* This program is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License, version 2.1 as published by the Free Software
* Foundation.
*
* You should have received a copy of the GNU Lesser General Public License along with this
* program; if not, you can obtain a copy at http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html
* or from the Free Software Foundation, Inc.,
* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*
* This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
* See the GNU Lesser General Public License for more details.
*
* Copyright (c) 2002-2017 Hitachi Vantara..  All rights reserved.
--%>

<!DOCTYPE html>
<%@page pageEncoding="UTF-8" %>
<%@
    page language="java"
    import="org.apache.commons.lang.StringUtils,
            org.owasp.encoder.Encode,
            org.pentaho.platform.util.messages.LocaleHelper,
            java.net.URL,
            java.net.URLClassLoader,
            java.util.ArrayList,
            java.util.Iterator,
            java.util.LinkedHashMap,
            java.util.List,
            java.util.Locale,
            java.util.Map,
            java.util.ResourceBundle,
            org.pentaho.platform.api.engine.IAuthorizationPolicy,
            org.pentaho.platform.api.engine.IPluginManager,
            org.pentaho.platform.engine.core.system.PentahoSessionHolder,
            org.pentaho.platform.engine.core.system.PentahoSystem,
            org.pentaho.platform.security.policy.rolebased.actions.AdministerSecurityAction,
            org.pentaho.platform.security.policy.rolebased.actions.RepositoryCreateAction"%>
<%
  boolean canCreateContent = PentahoSystem.get(IAuthorizationPolicy.class, PentahoSessionHolder.getSession()).isAllowed(RepositoryCreateAction.NAME);
  boolean canAdminister = PentahoSystem.get(IAuthorizationPolicy.class, PentahoSessionHolder.getSession()).isAllowed(AdministerSecurityAction.NAME);
  boolean hasDataAccessPlugin = PentahoSystem.get( IPluginManager.class, PentahoSessionHolder.getSession() ).getRegisteredPlugins().contains( "data-access" );

  Locale effectiveLocale = request.getLocale();
  if ( !StringUtils.isEmpty( request.getParameter( "locale" ) ) ) {
    request.getSession().setAttribute( "locale_override", request.getParameter( "locale" ) );
    LocaleHelper.parseAndSetLocaleOverride( request.getParameter( "locale" ) );
  } else {
    request.getSession().setAttribute( "locale_override", null );
    LocaleHelper.setLocaleOverride( null );
  }

  URLClassLoader loader = new URLClassLoader( new URL[] { application.getResource( "/mantle/messages/" ) } );
  ResourceBundle properties = ResourceBundle.getBundle( "mantleMessages", request.getLocale(), loader );

%>

<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <title><%= properties.getString("productName") %></title>

  <%
    boolean haveMobileRedirect = false;
    String ua = request.getHeader( "User-Agent" ).toLowerCase();
    if ( !"desktop".equalsIgnoreCase( request.getParameter( "mode") ) ) {
      if ( ua.contains( "ipad" ) || ua.contains( "ipod" ) || ua.contains( "iphone" )
         || ua.contains( "android" ) || "mobile".equalsIgnoreCase( request.getParameter( "mode" ) ) ) {
        IPluginManager pluginManager = PentahoSystem.get( IPluginManager.class, PentahoSessionHolder.getSession() );
        List<String> pluginIds = pluginManager.getRegisteredPlugins();
        for ( String id : pluginIds ) {
          String mobileRedirect = (String)pluginManager.getPluginSetting( id, "mobile-redirect", null );
          if ( mobileRedirect != null ) {
            // we have a mobile redirect
            haveMobileRedirect = true;
            String queryString = request.getQueryString();
            if( queryString != null ) {
              final Map<String, String> queryPairs = new LinkedHashMap<String, String>();
              //Check for deep linking by fetching the name and startup-url values from URL query parameters
              String[] pairs = queryString.split( "&" );
              for ( String pair : pairs ) {
                int delimiter = pair.indexOf( "=" );
                queryPairs.put( Encode.forJavaScript( pair.substring( 0, delimiter ) ),  Encode.forJavaScript( pair.substring( delimiter + 1 ) ) );
              }
              if ( queryPairs.size() > 0 ) {
                mobileRedirect += "?";
                Iterator it = queryPairs.entrySet().iterator();
                while ( it.hasNext() ) {
                  Map.Entry entry = (Map.Entry) it.next();
                  mobileRedirect += entry.getKey() + "=" + entry.getValue();
                  it.remove();
                    if ( it.hasNext() ){
                      mobileRedirect += "&";
                    }
                }
              }
            }
  %>
  <script type="text/javascript">
    if(typeof window.parent.PentahoMobile != "undefined"){
      window.parent.location.reload();
    } else {
      var tag = document.createElement('META');
      tag.setAttribute('HTTP-EQUIV', 'refresh');
      tag.setAttribute('CONTENT', '0;URL=<%=mobileRedirect%>');
      document.getElementsByTagName('HEAD')[0].appendChild(tag);
    }
  </script>
  <%
          break;
          }
        }
      }
    if (!haveMobileRedirect) {
  %>
  <meta name="gwt:property" content="locale=<%=Encode.forHtmlAttribute(effectiveLocale.toString())%>">
  <link rel="icon" href="/pentaho-style/favicon.ico"/>
  <link rel="apple-touch-icon" sizes="180x180" href="/pentaho-style/apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="/pentaho-style/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="/pentaho-style/favicon-16x16.png">
  <link rel="mask-icon" href="/pentaho-style/safari-pinned-tab.svg" color="#cc0000">
  <link rel='stylesheet' href='mantle/MantleStyle.css'/>
  <%if ( hasDataAccessPlugin ) {%>
  <link rel="stylesheet" href="content/data-access/resources/gwt/datasourceEditorDialog.css"/>
  <%}%>

  <!-- ANGULAR INCLUDES -->
  <link rel="stylesheet" href="content/common-ui/resources/themes/css/angular-animations.css">
  <script language="javascript" type="text/javascript" src="webcontext.js?context=mantle"></script>

  <script src="mantle/themes/stratebi/vendor/bootstrap/js/bootstrap.min.js" async></script>
  <link rel="stylesheet" href="mantle/themes/stratebi/vendor/bootstrap/css/bootstrap.min.css">
  <link rel="stylesheet" href="mantle/themes/stratebi/vendor/font-awesome/css/font-awesome.min.css">

  <script type="text/javascript" src="mantle/nativeScripts.js"></script>
  <script type="text/javascript">
    try{
    if (window.opener && window.opener.reportWindowOpened != undefined) {
      window.opener.reportWindowOpened();
    }
    } catch(/* XSS */ ignored){}

    var dataAccessAvailable = false; //Used by child iframes to tell if data access is available.
    /* this function is called by the gwt code when initing, if the user has permission */
    function initDataAccess(hasAccess) {
      dataAccessAvailable = hasAccess;
      if (!hasAccess) {
        return;
      }
      if (typeof(addMenuItem) == "undefined") {
        setTimeout("initDataAccess(" + hasAccess + ")", 1000);
        return;
      } else {
        addMenuItem("manageDatasourcesEllipsis", "manage_content_menu", "ManageDatasourcesCommand");
        addMenuItem("newDatasource", "new_menu", "AddDatasourceCommand");
      }
    }

    var datasourceEditorCallback = {
      onFinish: function (val, transport) {
      },
      onError: function (val) {
        alert('error:' + val);
      },
      onCancel: function () {
      },
      onReady: function () {
      }
    }

    // This allows content panels to have PUC create new datasources. The iframe requesting
    // the new datasource must have a function "openDatasourceEditorCallback" on it's window scope
    // to be notified of the successful creation of the datasource.
    function openDatasourceEditorIFrameProxy(windowReference) {
      var callbackHelper = function (bool, transport) {
        windowReference.openDatasourceEditorCallback(bool, transport);
      }
      pho.openDatasourceEditor(new function () {
        this.onError = function (err) {
          alert(err);
        }
        this.onCancel = function () {
        }
        this.onReady = function () {
        }
        this.onFinish = function (bool, transport) {
          callbackHelper(bool, transport);
        }
      });
    }

    // Require Angular Plugin Initialization
    require(['mantle/puc-api/pucAngularApi']);
    $( document ).ready(function() {

    (function() {
      var buscar = function() {
          window.parent.mantle_setPerspective('search.perspective');
          var palabra = $('#buscador', window.parent.document)[0].value;
          var contentWindow = document.getElementById('search.perspective').contentWindow;
          if (contentWindow.accion_buscar) contentWindow.accion_buscar(palabra);
      };
      $('#buscar').on('click', buscar);
      $('#buscador').on('keyup', function(e) { if (e.keyCode == 13) buscar(); });
    })();

  });

  </script>
<style>
#pucContent{
  left:50px;
}
#menu_sidebar{
  width:50px;
  background:#7A9E3F;
  color:white;
  min-height:200px;
  height:100%;
  position: absolute;
  z-index:1;
}
#menu_sidebar .btn:hover {
  position: relative;
}
#menu_sidebar .fa{
font-size: 25px;
}
#menu_sidebar .btn.btn-large.btn-block .fa{
font-size: 20px;
}
#menu_sidebar .btn,
#pucContent .btn {
    background: #769D49;

    padding: 13px 20px;
    border-radius: 0px;
}
#menu_sidebar .new_olap:hover{
    background: #b0b916;
    color:white;
    border-radius: 0px !important;
    -webkit-transition: all .2s ease;
  -o-transition: all .2s ease;
  -ms-transition: all .2s ease;
  transition: all .2s ease;    
  }
#menu_sidebar .new_score:hover{
    background: #066653;    
        color:white;
    -webkit-transition: all .2s ease;
  -o-transition: all .2s ease;
  -ms-transition: all .2s ease;
  transition: all .2s ease;
    border-radius: 0px !important;
  }
#menu_sidebar .new_report:hover{
    background: #e67d21;
        color:white;
    -webkit-transition: all .2s ease;
  -o-transition: all .2s ease;
  -ms-transition: all .2s ease;
  transition: all .2s ease;
    border-radius: 0px !important;
  }
#menu_sidebar .new_agile:hover{
    background: #ff0000;
        color:white;
    -webkit-transition: all .2s ease;
  -o-transition: all .2s ease;
  -ms-transition: all .2s ease;
  transition: all .2s ease;
    border-radius: 0px !important;
  }
#menu_sidebar .new_dash:hover{
    background: #2a80b8;
        color:white;
    -webkit-transition: all .2s ease;
  -o-transition: all .2s ease;
  -ms-transition: all .2s ease;
  transition: all .2s ease;
    border-radius: 0px !important;
  } 
  .pucProfile3{
    padding-top: 15px;
    text-align: right;
    right: 50px;
  }
  #boton_buscar{
    width: 30px;
    padding-left: 10px;
    padding-right: 10px;
    margin-left: -40px;
    margin-top: -2px;
    height: 30px;
  }
  .btn-block+.btn-block {
    margin-top: 0px !important;
}
.popupContent{
     box-shadow: 0px 0px 10px #ccc
}
.popupContent td {
    height: 20px;
    padding: 3px;
    cursor: pointer;
    padding-left: 10px;
    padding-right: 10px;
    -webkit-transition: all .2s ease;
  -o-transition: all .2s ease;
  -ms-transition: all .2s ease;
  transition: all .2s ease;   
  background:white; 
}
.popupContent>td:hover {
    background:#729c51;
    color:white;
    -webkit-transition: all .2s ease;
  -o-transition: all .2s ease;
  -ms-transition: all .2s ease;
  transition: all .2s ease;
}
.pentaho-tabWidget {
    display: inline-flex !important;
}
.pentaho-tabWidget-selected {
    border-top: solid 1px #ccc  !important;
    border-left: solid 1px #ccc !important;
    border-right: solid 1px #ccc !important;
}
.bootstrap .modal-backdrop{
  background-color:#333 !important;
}
/********************************************/


@import url(http://fonts.googleapis.com/css?family=Roboto:700);
#cssmenu,
#cssmenu ul,
#cssmenu ul li,
#cssmenu ul li a {
  margin: 0;
  padding: 0;
  border: 0;
  list-style: none;
  line-height: 1;
  display: block;
  position: relative;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
  background:#769D49;
  color:white;
  -webkit-transition: all .4s ease;
  -o-transition: all .4s ease;
  -ms-transition: all .4s ease;
  transition: all .4s ease;
}#cssmenu ul li a:hover {
  background:#f6f6f6;
  color:#769D49 !important;
  -webkit-transition: all .4s ease;
  -o-transition: all .4s ease;
  -ms-transition: all .4s ease;
  transition: all .4s ease;
}
#cssmenu {
  font-family: Roboto, sans-serif;
}
#cssmenu > ul {
    width: auto;
    background: transparent;
}
#cssmenu > ul > li > a {
  padding: 12px;
  font-size: 14px;
  color: #fff;
  font-weight: 700;
  text-decoration: none;
  -webkit-transition: color .2s ease;
  -o-transition: color .2s ease;
  -ms-transition: color .2s ease;
  transition: color .2s ease;
  text-align: center;
  vertical-align: bottom;
}
#cssmenu > ul > li:hover > a,
#cssmenu > ul > li > a:hover {
  color: #222222;
}
#cssmenu ul li.has-sub > a::after {
  position: absolute;
  right: 15px;
  display: block;
  width: 10px;
  height: 10px;
  content: "";
  border-radius: 2px;
}
#cssmenu > ul > li.has-sub > a::after {
  top: 14px;
  background: #666666;
}
#cssmenu > ul > li.has-sub:hover > a::after,
#cssmenu > ul > li.has-sub > a:hover::after {
  background: #222222;
}
#cssmenu ul ul li.has-sub > a::after {
  top: 13px;
  background: #ffffff;
}
#cssmenu ul ul li.has-sub:hover > a::after,
#cssmenu ul ul li.has-sub > a:hover::after {
  background: #dddddd;
}
#cssmenu ul li.has-sub > a::before {
  position: absolute;
  right: 15px;
  z-index: 2;
  display: block;
  width: 0;
  height: 0;
  border: 3px solid transparent;
  content: "";
}
#cssmenu > ul > li.has-sub > a::before {
  top: 16px;
  border-left-color: #ffffff;
}
#cssmenu ul ul li.has-sub > a::before {
  top: 15px;
  border-left-color: #2e353b;
}
#cssmenu ul {
  -webkit-perspective: 600px;
  -moz-perspective: 600px;
  perspective: 600px;
  -webkit-transform-style: preserve-3d;
  -moz-transform-style: preserve-3d;
  transform-style: preserve-3d;
}
#cssmenu ul ul {
  position: absolute;
  top: 0;
  left: -9999px;
  opacity: 0;
  -moz-transition: opacity 0.6s ease, -moz-transform 0.6s ease;
  -webkit-transition: opacity 0.6s ease, -webkit-transform 0.6s ease;
  -ms-transition: opacity 0.6s ease, -ms-transform 0.6s ease;
  -o-transition: opacity 0.6s ease, -o-transform 0.6s ease;
  transition: opacity .6s ease, transform .6s ease;
  -webkit-transform: rotate3d(0, 1, 0, 45deg);
  -moz-transform: rotate3d(0, 1, 0, 45deg);
  transform: rotate3d(0, 1, 0, 45deg);
  -webkit-transform-origin: left center;
  -moz-transform-origin: left center;
  transform-origin: left center;
  -webkit-backface-visibility: hidden;
  -moz-backface-visibility: hidden;
  backface-visibility: hidden;
}
#cssmenu ul li:hover > ul {
  left: 100%;
  opacity: 1;
  transform: rotate3d(0, 0, 0, 0);
}
#cssmenu ul ul a {
  font-size: 12px;
  color: #ffffff;
  font-weight: 700;
  text-decoration: none;
  -webkit-transition: color .2s ease;
  -o-transition: color .2s ease;
  -ms-transition: color .2s ease;
  transition: color .2s ease;
}
#cssmenu ul ul li:hover > a,
#cssmenu ul ul li a:hover {
  color: #dddddd;
}
#cssmenu .btn.btn-large.btn-block img {
    height: 18px;
}
#cssmenu .btn{
text-align: left;
}
</style>
</head>

<body oncontextmenu="return false;" class="pentaho-page-background">

  <div ng-show="viewContainer === 'PUC'" 
    class="ng-app-element deny-animation-change" animate="fade" 
    id="pucWrapper" cellspacing="0" cellpadding="0" style="width: 100%; height: 100%;">

    <%@ include file="./fragments/Header.jspf" %>

    <%@ include file="./fragments/SideBar.jspf" %>

    <div id="pucContent"></div>

  </div>

  <div ng-view ng-show="viewContainer === 'ngView'" class="ng-app-view ng-app-element"></div>
  

<script type="text/javascript">
  document.getElementById("pucWrapper").style.position = "absolute";
  document.getElementById("pucWrapper").style.left = "-5000px";
  require(["common-ui/util/BusyIndicator"], function (busy) {

    busy.show("<%= properties.getString("pleaseWait") %>", "<%= properties.getString("loadingConsole") %>", "pucPleaseWait");

    window.notifyOfLoad = function (area) {
      var allFramesLoaded = true;
      for (var i = 0; i < window.frames.length; i++) {
        try{
          if (window.frames[i].document.readyState != "complete") {
            allFramesLoaded = false;
            break;
          }
        } catch(ignored){
          // likely a XSS issue.
        }
      }

      if (allFramesLoaded) {
        busy.hide("pucPleaseWait");
        document.getElementById("pucWrapper").style.left = "0";
        document.getElementById("pucWrapper").style.position = "relative";
        window.allFramesLoaded = true;
      } else {
        // check again in a bit
        setTimeout("notifyOfLoad()", 300);
      }
    }


    // Remove when notifyOfLoad is called from PUC
    setTimeout(function () {
      notifyOfLoad();
    }, 4000);
  });

</script>

<!-- OPTIONAL: include this if you want history support -->

</body>

<script language='javascript' src='mantle/mantle.nocache.js'></script>
<%if ( hasDataAccessPlugin ) {%>
<script language='javascript' src='content/data-access/resources/gwt/DatasourceEditor.nocache.js'></script>
<%}}}%>

</html>