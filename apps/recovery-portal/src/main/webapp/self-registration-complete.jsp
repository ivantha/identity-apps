<%--
  ~ Copyright (c) 2016, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
  ~
  ~  WSO2 Inc. licenses this file to you under the Apache License,
  ~  Version 2.0 (the "License"); you may not use this file except
  ~  in compliance with the License.
  ~  You may obtain a copy of the License at
  ~
  ~    http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
 --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.IdentityManagementEndpointConstants" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.IdentityManagementEndpointUtil" %>
<%@ page import="java.net.MalformedURLException" %>
<%@ page import="java.io.File" %>

<jsp:directive.include file="includes/localize.jsp"/>
<%
    boolean isEmailNotificationEnabled = false;

    String callback = (String) request.getAttribute("callback");
    if (StringUtils.isBlank(callback)) {
        callback = IdentityManagementEndpointUtil.getUserPortalUrl(
                application.getInitParameter(IdentityManagementEndpointConstants.ConfigConstants.USER_PORTAL_URL));
    }
    String confirm = (String) request.getAttribute("confirm");

    isEmailNotificationEnabled = Boolean.parseBoolean(application.getInitParameter(
            IdentityManagementEndpointConstants.ConfigConstants.ENABLE_EMAIL_NOTIFICATION));
%>

<!doctype html>
<html>
<head>
    <%
        File headerFile = new File(getServletContext().getRealPath("extensions/header.jsp"));
        if (headerFile.exists()) {
    %>
    <jsp:include page="extensions/header.jsp"/>
    <% } else { %>
    <jsp:directive.include file="includes/header.jsp"/>
    <% } %>

    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=UA-148957636-1"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());

        gtag('config', 'UA-148957636-1');
    </script>

    <!-- start Mixpanel -->
    <script type="text/javascript">(function(c,a){if(!a.__SV){var b=window;try{var d,m,j,k=b.location,f=k.hash;d=function(a,b){return(m=a.match(RegExp(b+"=([^&]*)")))?m[1]:null};f&&d(f,"state")&&(j=JSON.parse(decodeURIComponent(d(f,"state"))),"mpeditor"===j.action&&(b.sessionStorage.setItem("_mpcehash",f),history.replaceState(j.desiredHash||"",c.title,k.pathname+k.search)))}catch(n){}var l,h;window.mixpanel=a;a._i=[];a.init=function(b,d,g){function c(b,i){var a=i.split(".");2==a.length&&(b=b[a[0]],i=a[1]);b[i]=function(){b.push([i].concat(Array.prototype.slice.call(arguments,
        0)))}}var e=a;"undefined"!==typeof g?e=a[g]=[]:g="mixpanel";e.people=e.people||[];e.toString=function(b){var a="mixpanel";"mixpanel"!==g&&(a+="."+g);b||(a+=" (stub)");return a};e.people.toString=function(){return e.toString(1)+".people (stub)"};l="disable time_event track track_pageview track_links track_forms track_with_groups add_group set_group remove_group register register_once alias unregister identify name_tag set_config reset opt_in_tracking opt_out_tracking has_opted_in_tracking has_opted_out_tracking clear_opt_in_out_tracking people.set people.set_once people.unset people.increment people.append people.union people.track_charge people.clear_charges people.delete_user people.remove".split(" ");
        for(h=0;h<l.length;h++)c(e,l[h]);var f="set set_once union unset remove delete".split(" ");e.get_group=function(){function a(c){b[c]=function(){call2_args=arguments;call2=[c].concat(Array.prototype.slice.call(call2_args,0));e.push([d,call2])}}for(var b={},d=["get_group"].concat(Array.prototype.slice.call(arguments,0)),c=0;c<f.length;c++)a(f[c]);return b};a._i.push([b,d,g])};a.__SV=1.2;b=c.createElement("script");b.type="text/javascript";b.async=!0;b.src="undefined"!==typeof MIXPANEL_CUSTOM_LIB_URL?
        MIXPANEL_CUSTOM_LIB_URL:"file:"===c.location.protocol&&"//cdn4.mxpnl.com/libs/mixpanel-2-latest.min.js".match(/^\/\//)?"https://cdn4.mxpnl.com/libs/mixpanel-2-latest.min.js":"//cdn4.mxpnl.com/libs/mixpanel-2-latest.min.js";d=c.getElementsByTagName("script")[0];d.parentNode.insertBefore(b,d)}})(document,window.mixpanel||[]);
    mixpanel.init("7e7424080280423369384bdcd4a254b8");
    </script>
    <!-- end Mixpanel -->

    <script>
        gtag("event", "self-registration-complete.jsp", {
            "event_category": "registration_success",
            "event_label": "Self registration successful",
        });

        mixpanel.track("WSO2-IS", {
            "event_action": "self-registration-complete.jsp",
            "event_category": "registration_success",
            "event_label": "Self registration successful",
        });
    </script>
</head>
<body>
<div class="ui tiny modal notify">
    <div class="header">
        <h4>
            <%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Information")%>
        </h4>
    </div>
    <div class="content">
        <% if (StringUtils.isNotBlank(confirm) && confirm.equals("true")) {%>
        <p><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Successfully.confirmed")%>
        </p>
        <%
        } else {
            if (isEmailNotificationEnabled) {
        %>
        <p><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Confirmation.sent.to.mail")%>
        </p>
        <% } else {%>
        <p><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle,
                "User.registration.completed.successfully")%>
        </p>
        <%
                }
            }
        %>
    </div>
    <div class="actions">
        <button type="button" class="ui primary button cancel" data-dismiss="modal">
            <%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Close")%>
        </button>
    </div>
</div>

<!-- footer -->
<%
    File footerFile = new File(getServletContext().getRealPath("extensions/footer.jsp"));
    if (footerFile.exists()) {
%>
<jsp:include page="extensions/footer.jsp"/>
<% } else { %>
<jsp:directive.include file="includes/footer.jsp"/>
<% } %>

<script type="application/javascript">
    $(document).ready(function () {

        $('.notify').modal({
            onHide: function () {
                <%
                    try {
                %>
                location.href = "<%= IdentityManagementEndpointUtil.encodeURL(callback)%>";
                <%
                } catch (MalformedURLException e) {
                    request.setAttribute("error", true);
                    request.setAttribute("errorMsg", "Invalid callback URL found in the request.");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                    return;
                }
                %>
            },
            blurring: true,
            detachable: true,
            closable: false,
            centered: true,
        }).modal("show");

    });
</script>
</body>
</html>
