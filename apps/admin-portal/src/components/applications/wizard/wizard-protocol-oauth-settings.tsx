/**
 * Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import { Field, Forms, Validation } from "@wso2is/forms";
import { Hint } from "@wso2is/react-components";
import { FormValidation } from "@wso2is/validation";
import React, { FunctionComponent } from "react";
import { Button, Grid } from "semantic-ui-react";
import { MainApplicationInterface, OIDCDataInterface } from "../../../models";

interface OAuthProtocolSettingsProps {
    templateData: MainApplicationInterface;
    OIDCdata: OIDCDataInterface;
    setOIDCdata: any;
    next: any;
    back: any;
}

/**
 * Captures Oauth protocol settings.
 *
 * @param props OAuthProtocolSettingsProps
 */
export const WizardOAuthProtocolSettings: FunctionComponent<OAuthProtocolSettingsProps> = (props): JSX.Element => {
    const {
        OIDCdata,
        setOIDCdata,
        templateData,
        back,
        next,
    } = props;

    const buildCallBackUrlWithRegExp = (urls: string): string => {
        let callbackURLs = urls;
        if (callbackURLs.split(",").length > 1) {
            callbackURLs = "regexp=(" + callbackURLs.split(",").join("|") + ")";
        }
        return callbackURLs;
    };

    const buildCallBackURLWithSeparator = (url: string): string => {
        if (url.includes("regexp=(")) {
            url = url.replace("regexp=(", "");
            url = url.replace(")", "");
            url = url.split("|").join(",");
        }
        return url;
    };

    const handleSubmit = (values) => {
        const submit: OIDCDataInterface = {
            callbackURLs: [buildCallBackUrlWithRegExp(values.get("callbackURL"))],
            grantTypes: templateData.inboundProtocolConfiguration.oidc.grantTypes,
            publicClient: values.get("publicClients").includes("supportPublicClients"),
        };
        setOIDCdata(submit);
        next();
    };

    return (
        <>
            {
                (
                    <Forms
                        onSubmit={ (values) => {
                            handleSubmit(values);
                        } }
                    >
                        <Grid className={ "protocolForm" }>
                            <Grid.Row columns={ 1 } className={ "protocolRow" }>
                                <Grid.Column mobile={ 16 } tablet={ 16 } computer={ 14 } className="protocolColumn">
                                    <Field
                                        name="callbackURL"
                                        label="CallbackURL"
                                        required={ true }
                                        requiredErrorMessage="this is needed"
                                        placeholder="Enter the CallbackURL"
                                        type="text"
                                        validation={ (value: string, validation: Validation) => {
                                            const urlList = value.split(",");
                                            urlList.map((singleUrl) => {
                                                if (!FormValidation.url(singleUrl)) {
                                                    validation.isValid = false;
                                                    validation.errorMessages.push(
                                                        "Please add valid URLs with comma separation."
                                                    );
                                                }
                                            });
                                        } }
                                        value={ OIDCdata &&
                                        buildCallBackURLWithSeparator(OIDCdata.callbackURLs?.toString()) }
                                    />
                                    <Hint>
                                        After the authentication, we will only redirect to the above callback
                                        URLs.
                                        You can specify multiple URLs by separating them using a comma.
                                    </Hint>

                                </Grid.Column>
                            </Grid.Row>
                            <Grid.Row columns={ 1 }>
                                <Grid.Column mobile={ 16 } tablet={ 16 } computer={ 14 }>
                                    <Field
                                        name="publicClients"
                                        label=""
                                        required={ false }
                                        requiredErrorMessage="this is needed"
                                        type="checkbox"
                                        value={
                                            templateData &&
                                            templateData.inboundProtocolConfiguration.oidc.publicClient ?
                                                ["supportPublicClients"] : []
                                        }
                                        children={ [
                                            {
                                                label: "Public Client",
                                                value: "supportPublicClients"
                                            }
                                        ] }
                                    />
                                    <Hint>
                                        Allow the client to authenticate without a client secret.
                                    </Hint>
                                </Grid.Column>
                            </Grid.Row>
                            <Grid.Row columns={ 3 } className={ "protocolRow" }>
                                <Grid.Column mobile={ 16 } tablet={ 16 } computer={ 3 }>
                                    <Button onClick={ back } size="small" className="form-button">
                                        Back
                                    </Button>
                                </Grid.Column>
                                <Grid.Column mobile={ 16 } tablet={ 16 } computer={ 10 }/>
                                <Grid.Column mobile={ 16 } tablet={ 16 } computer={ 3 }>
                                    <Button primary type="submit" size="small" className="form-button">
                                        Next
                                    </Button>
                                </Grid.Column>
                            </Grid.Row>
                        </Grid>
                    </Forms>
                )
            }
        </>
    );
};