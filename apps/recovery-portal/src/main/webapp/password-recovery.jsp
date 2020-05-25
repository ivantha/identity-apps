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
<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.IdentityManagementEndpointConstants" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.client.ApiException" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.client.api.ReCaptchaApi" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.client.model.ReCaptchaProperties" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.client.model.User" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.util.IdentityManagementEndpointUtil" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.*" %>

<jsp:directive.include file="includes/localize.jsp"/>

<%
    boolean error = IdentityManagementEndpointUtil.getBooleanValue(request.getAttribute("error"));
    String errorMsg = IdentityManagementEndpointUtil.getStringValue(request.getAttribute("errorMsg"));
    String username = request.getParameter("username");
    String tenantDomain = request.getParameter("tenantDomain");
    boolean isSaaSApp = Boolean.parseBoolean(request.getParameter("isSaaSApp"));

    if (StringUtils.isBlank(tenantDomain)) {
        tenantDomain = IdentityManagementEndpointConstants.SUPER_TENANT;
    }

    ReCaptchaApi reCaptchaApi = new ReCaptchaApi();
    try {
        ReCaptchaProperties reCaptchaProperties = reCaptchaApi.getReCaptcha(tenantDomain, true, "ReCaptcha",
                "password-recovery");

        if (reCaptchaProperties.getReCaptchaEnabled()) {
            Map<String, List<String>> headers = new HashMap<>();
            headers.put("reCaptcha", Arrays.asList(String.valueOf(true)));
            headers.put("reCaptchaAPI", Arrays.asList(reCaptchaProperties.getReCaptchaAPI()));
            headers.put("reCaptchaKey", Arrays.asList(reCaptchaProperties.getReCaptchaKey()));
            IdentityManagementEndpointUtil.addReCaptchaHeaders(request, headers);
        }
    } catch (ApiException e) {
        request.setAttribute("error", true);
        request.setAttribute("errorMsg", e.getMessage());
        request.getRequestDispatcher("error.jsp").forward(request, response);
        return;
    }

    boolean isEmailNotificationEnabled = false;

    isEmailNotificationEnabled = Boolean.parseBoolean(application.getInitParameter(
            IdentityManagementEndpointConstants.ConfigConstants.ENABLE_EMAIL_NOTIFICATION));

    boolean reCaptchaEnabled = false;

    if (request.getAttribute("reCaptcha") != null &&
            "TRUE".equalsIgnoreCase((String) request.getAttribute("reCaptcha"))) {
        reCaptchaEnabled = true;
    }
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

    <%
        if (reCaptchaEnabled) {
    %>
    <script src='<%=(request.getAttribute("reCaptchaAPI"))%>'></script>
    <%
        }
    %>

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
        gtag("event", "password-recovery.jsp", {
            "event_category": "recovery",
            "event_label": "Recovery opened",
        });

        mixpanel.track("WSO2-IS", {
            "event_action": "password-recovery.jsp",
            "event_category": "recovery",
            "event_label": "Recovery opened",
        });
    </script>
</head>
<body>
    <main class="center-segment">
        <div class="ui container medium center aligned middle aligned">
            <!-- product-title -->
            <%
                File productTitleFile = new File(getServletContext().getRealPath("extensions/product-title.jsp"));
                if (productTitleFile.exists()) {
            %>
            <jsp:include page="extensions/product-title.jsp"/>
            <% } else { %>
            <jsp:directive.include file="includes/product-title.jsp"/>
            <% } %>
            <div class="ui segment">
                <!-- page content -->
                <h3 class="ui header">
                    <%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Recover.password")%>
                </h3>
                <% if (error) { %>
                <div class="ui visible negative message" id="server-error-msg">
                    <%=IdentityManagementEndpointUtil.i18nBase64(recoveryResourceBundle, errorMsg)%>
                </div>
                <% } %>
                <div class="ui negative message" id="error-msg" hidden="hidden"></div>

                <div class="ui divider hidden"></div>
                <div class="segment-form">
                    <form class="ui large form" method="post" action="verify.do" id="recoverDetailsForm">
                        <%
                            if (StringUtils.isNotEmpty(username) && !error) {
                        %>
                        <div class="field">
                            <input type="hidden" name="username" value="<%=Encode.forHtmlAttribute(username)%>"/>
                        </div>
                        <%
                        } else {
                        %>

                        <div class="field">
                            <label for="username">
                                <%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Enter.your.username.here")%>
                            </label>
                            <input id="usernameUserInput" name="usernameUserInput" type="text" tabindex="0" required>
                            <input id="username" name="username" type="hidden">
                            <input id="tenantDomain" name="tenantDomain" value="<%= tenantDomain %>" type="hidden">
                            <input id="isSaaSApp" name="isSaaSApp" value="<%= isSaaSApp %>" type="hidden">
                        </div>

                        <%
                            }
                        %>

                        <% if (isEmailNotificationEnabled) { %>
                        <div class="ui secondary segment" style="text-align: left;">
                            <div class="field">
                                <div class="ui radio checkbox">
                                    <input type="radio" name="recoveryOption" value="EMAIL" checked/>
                                    <label><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Recover.with.mail")%>
                                    </label>
                                </div>
                            </div>
                            <div class="field">
                                <div class="ui radio checkbox">
                                    <input type="radio" name="recoveryOption" value="SECURITY_QUESTIONS"/>
                                    <label><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Recover.with.question")%>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <% } else { %>
                        <div class="field">
                            <input type="hidden" name="recoveryOption" value="SECURITY_QUESTIONS"/>
                        </div>
                        <% } %>

                        <%
                            String callback = request.getParameter("callback");
                            if (callback != null) {
                        %>
                        <div>
                            <input type="hidden" name="callback" value="<%=Encode.forHtmlAttribute(callback) %>"/>
                        </div>
                        <%
                            }
                        %>

                        <%
                            if (reCaptchaEnabled) {
                        %>
                        <div class="field">
                            <div class="g-recaptcha"
                                 data-sitekey=
                                         "<%=Encode.forHtmlContent((String)request.getAttribute("reCaptchaKey"))%>">
                            </div>
                        </div>
                        <%
                            }
                        %>
                        <div class="ui divider hidden"></div>
                        <div class="align-right buttons">
                            <a href="javascript:goBack()" class="ui button link-button">
                                <%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Cancel")%>
                            </a>
                            <button id="recoverySubmit"
                                    class="ui primary button"
                                    type="submit">
                                <%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Submit")%>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
    <!-- /content/body -->
    <!-- product-footer -->
    <%
        File productFooterFile = new File(getServletContext().getRealPath("extensions/product-footer.jsp"));
        if (productFooterFile.exists()) {
    %>
    <jsp:include page="extensions/product-footer.jsp"/>
    <% } else { %>
    <jsp:directive.include file="includes/product-footer.jsp"/>
    <% } %>
    <!-- footer -->
    <%
        File footerFile = new File(getServletContext().getRealPath("extensions/footer.jsp"));
        if (footerFile.exists()) {
    %>
    <jsp:include page="extensions/footer.jsp"/>
    <% } else { %>
    <jsp:directive.include file="includes/footer.jsp"/>
    <% } %>

    <script type="text/javascript">
        function goBack() {
            window.history.back();
        }

        $(document).ready(function () {

            $("#recoverDetailsForm").submit(function (e) {
                var errorMessage = $("#error-msg");
                errorMessage.hide();

                var userName = document.getElementById("username");
                var usernameUserInput = document.getElementById("usernameUserInput");
                if (usernameUserInput) {
                    userName.value = usernameUserInput.value.trim();
                }
                // Validate User Name
                var firstName = $("#username").val();

                if (firstName == '') {
                    errorMessage.text("Please fill the first name.");
                    errorMessage.show();
                    $("html, body").animate({scrollTop: errorMessage.offset().top}, 'slow');

                    return false;
                }

                // Validate reCaptcha
                <% if (reCaptchaEnabled) { %>

                var reCaptchaResponse = $("[name='g-recaptcha-response']")[0].value;

                if (reCaptchaResponse.trim() == '') {
                    errorMessage.text("Please select reCaptcha.");
                    errorMessage.show();
                    $("html, body").animate({scrollTop: errorMessage.offset().top}, 'slow');

                    return false;
                }

                <% } %>

                return true;
            });
        });

    </script>
</body>
</html>
