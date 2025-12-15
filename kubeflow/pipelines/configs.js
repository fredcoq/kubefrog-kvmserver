"use strict";
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
// Copyright 2019 The Kubeflow Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
var path = __importStar(require("path"));
var utils_1 = require("./utils");
var artifacts_1 = require("./handlers/artifacts");
exports.BASEPATH = '/pipeline';
exports.apiVersion1 = 'v1beta1';
exports.apiVersion1Prefix = "apis/" + exports.apiVersion1;
exports.apiVersion2 = 'v2beta1';
exports.apiVersion2Prefix = "apis/" + exports.apiVersion2;
var Deployments;
(function (Deployments) {
    Deployments["NOT_SPECIFIED"] = "NOT_SPECIFIED";
    Deployments["KUBEFLOW"] = "KUBEFLOW";
    Deployments["MARKETPLACE"] = "MARKETPLACE";
})(Deployments = exports.Deployments || (exports.Deployments = {}));
/** converts string to bool */
var asBool = function (value) { return ['true', '1'].includes(value.toLowerCase()); };
function parseArgs(argv) {
    if (argv.length < 3) {
        var msg = "  Usage: node server.js <static-dir> [port].\n         You can specify the API server address using the\n         ML_PIPELINE_SERVICE_HOST and ML_PIPELINE_SERVICE_PORT\n         env vars.";
        throw new Error(msg);
    }
    var staticDir = path.resolve(argv[2]);
    var port = parseInt(argv[3] || '3000', 10);
    return { staticDir: staticDir, port: port };
}
function loadConfigs(argv, env) {
    var _a = parseArgs(argv), staticDir = _a.staticDir, port = _a.port;
    /** All configurable environment variables can be found here. */
    var 
    /** minio client use these to retrieve minio objects/artifacts */
    _b = env.MINIO_ACCESS_KEY, 
    /** minio client use these to retrieve minio objects/artifacts */
    MINIO_ACCESS_KEY = _b === void 0 ? 'minio' : _b, _c = env.MINIO_SECRET_KEY, MINIO_SECRET_KEY = _c === void 0 ? 'minio123' : _c, _d = env.MINIO_PORT, MINIO_PORT = _d === void 0 ? '9000' : _d, _e = env.MINIO_HOST, MINIO_HOST = _e === void 0 ? 'minio-service' : _e, _f = env.MINIO_NAMESPACE, MINIO_NAMESPACE = _f === void 0 ? 'kubeflow' : _f, _g = env.MINIO_SSL, MINIO_SSL = _g === void 0 ? 'false' : _g, 
    /** minio client use these to retrieve s3 objects/artifacts */
    AWS_ACCESS_KEY_ID = env.AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY = env.AWS_SECRET_ACCESS_KEY, AWS_REGION = env.AWS_REGION, AWS_S3_ENDPOINT = env.AWS_S3_ENDPOINT, 
    /** http/https base URL */
    _h = env.HTTP_BASE_URL, 
    /** http/https base URL */
    HTTP_BASE_URL = _h === void 0 ? '' : _h, 
    /** By default, allowing access to all domains. Modify this flag to allow querying matching domains */
    _j = env.ALLOWED_ARTIFACT_DOMAIN_REGEX, 
    /** By default, allowing access to all domains. Modify this flag to allow querying matching domains */
    ALLOWED_ARTIFACT_DOMAIN_REGEX = _j === void 0 ? '^.*$' : _j, 
    /** http/https fetch with this authorization header key (for example: 'Authorization') */
    _k = env.HTTP_AUTHORIZATION_KEY, 
    /** http/https fetch with this authorization header key (for example: 'Authorization') */
    HTTP_AUTHORIZATION_KEY = _k === void 0 ? '' : _k, 
    /** http/https fetch with this authorization header value by default when absent in client request at above key */
    _l = env.HTTP_AUTHORIZATION_DEFAULT_VALUE, 
    /** http/https fetch with this authorization header value by default when absent in client request at above key */
    HTTP_AUTHORIZATION_DEFAULT_VALUE = _l === void 0 ? '' : _l, 
    /** API service will listen to this host */
    _m = env.ML_PIPELINE_SERVICE_HOST, 
    /** API service will listen to this host */
    ML_PIPELINE_SERVICE_HOST = _m === void 0 ? 'localhost' : _m, 
    /** API service will listen to this port */
    _o = env.ML_PIPELINE_SERVICE_PORT, 
    /** API service will listen to this port */
    ML_PIPELINE_SERVICE_PORT = _o === void 0 ? '3001' : _o, 
    /** path to viewer:tensorboard pod template spec */
    VIEWER_TENSORBOARD_POD_TEMPLATE_SPEC_PATH = env.VIEWER_TENSORBOARD_POD_TEMPLATE_SPEC_PATH, 
    /** Tensorflow image used for tensorboard viewer */
    _p = env.VIEWER_TENSORBOARD_TF_IMAGE_NAME, 
    /** Tensorflow image used for tensorboard viewer */
    VIEWER_TENSORBOARD_TF_IMAGE_NAME = _p === void 0 ? 'tensorflow/tensorflow' : _p, 
    /** Whether custom visualizations are allowed to be generated by the frontend */
    _q = env.ALLOW_CUSTOM_VISUALIZATIONS, 
    /** Whether custom visualizations are allowed to be generated by the frontend */
    ALLOW_CUSTOM_VISUALIZATIONS = _q === void 0 ? 'false' : _q, 
    /** Envoy service will listen to this host */
    _r = env.METADATA_ENVOY_SERVICE_SERVICE_HOST, 
    /** Envoy service will listen to this host */
    METADATA_ENVOY_SERVICE_SERVICE_HOST = _r === void 0 ? 'localhost' : _r, 
    /** Envoy service will listen to this port */
    _s = env.METADATA_ENVOY_SERVICE_SERVICE_PORT, 
    /** Envoy service will listen to this port */
    METADATA_ENVOY_SERVICE_SERVICE_PORT = _s === void 0 ? '9090' : _s, 
    /** Is Argo log archive enabled? */
    _t = env.ARGO_ARCHIVE_LOGS, 
    /** Is Argo log archive enabled? */
    ARGO_ARCHIVE_LOGS = _t === void 0 ? 'false' : _t, 
    /** Use minio or s3 client to retrieve archives. */
    _u = env.ARGO_ARCHIVE_ARTIFACTORY, 
    /** Use minio or s3 client to retrieve archives. */
    ARGO_ARCHIVE_ARTIFACTORY = _u === void 0 ? 'minio' : _u, 
    /** Bucket to retrive logs from */
    _v = env.ARGO_ARCHIVE_BUCKETNAME, 
    /** Bucket to retrive logs from */
    ARGO_ARCHIVE_BUCKETNAME = _v === void 0 ? 'mlpipeline' : _v, 
    /** Prefix to logs. */
    _w = env.ARGO_ARCHIVE_PREFIX, 
    /** Prefix to logs. */
    ARGO_ARCHIVE_PREFIX = _w === void 0 ? 'logs' : _w, 
    /** Should use server API for log streaming? */
    _x = env.STREAM_LOGS_FROM_SERVER_API, 
    /** Should use server API for log streaming? */
    STREAM_LOGS_FROM_SERVER_API = _x === void 0 ? 'false' : _x, 
    /** The main container name of a pod where logs are retrieved */
    _y = env.POD_LOG_CONTAINER_NAME, 
    /** The main container name of a pod where logs are retrieved */
    POD_LOG_CONTAINER_NAME = _y === void 0 ? 'main' : _y, 
    /** Disables GKE metadata endpoint. */
    _z = env.DISABLE_GKE_METADATA, 
    /** Disables GKE metadata endpoint. */
    DISABLE_GKE_METADATA = _z === void 0 ? 'false' : _z, 
    /** Enable authorization checks for multi user mode. */
    _0 = env.ENABLE_AUTHZ, 
    /** Enable authorization checks for multi user mode. */
    ENABLE_AUTHZ = _0 === void 0 ? 'false' : _0, 
    /** Deployment type. */
    _1 = env.DEPLOYMENT, 
    /** Deployment type. */
    DEPLOYMENT_STR = _1 === void 0 ? '' : _1, 
    /**
     * Set to true to hide the SideNav. When DEPLOYMENT is KUBEFLOW, HIDE_SIDENAV
     * defaults to true if not explicitly set to false.
     */
    HIDE_SIDENAV = env.HIDE_SIDENAV, 
    /**
     * A header user requests have when authenticated. It carries user identity information.
     * The default value works with Google Cloud IAP.
     */
    _2 = env.KUBEFLOW_USERID_HEADER, 
    /**
     * A header user requests have when authenticated. It carries user identity information.
     * The default value works with Google Cloud IAP.
     */
    KUBEFLOW_USERID_HEADER = _2 === void 0 ? 'x-goog-authenticated-user-email' : _2, 
    /**
     * KUBEFLOW_USERID_HEADER's value may have a prefix before user identity.
     * Use this header to specify what the prefix is.
     *
     * e.g. a valid header value for default values can be like `accounts.google.com:user@gmail.com`.
     */
    _3 = env.KUBEFLOW_USERID_PREFIX, 
    /**
     * KUBEFLOW_USERID_HEADER's value may have a prefix before user identity.
     * Use this header to specify what the prefix is.
     *
     * e.g. a valid header value for default values can be like `accounts.google.com:user@gmail.com`.
     */
    KUBEFLOW_USERID_PREFIX = _3 === void 0 ? 'accounts.google.com:' : _3;
    return {
        argo: {
            archiveArtifactory: ARGO_ARCHIVE_ARTIFACTORY,
            archiveBucketName: ARGO_ARCHIVE_BUCKETNAME,
            archiveLogs: asBool(ARGO_ARCHIVE_LOGS),
            archivePrefix: ARGO_ARCHIVE_PREFIX,
        },
        pod: {
            logContainerName: POD_LOG_CONTAINER_NAME,
        },
        artifacts: {
            aws: {
                accessKey: AWS_ACCESS_KEY_ID || '',
                endPoint: AWS_S3_ENDPOINT || 's3.amazonaws.com',
                region: AWS_REGION || 'us-east-1',
                secretKey: AWS_SECRET_ACCESS_KEY || '',
                useSSL: false,
                port:9000
            },
            http: {
                auth: {
                    defaultValue: HTTP_AUTHORIZATION_DEFAULT_VALUE,
                    key: HTTP_AUTHORIZATION_KEY,
                },
                baseUrl: HTTP_BASE_URL,
            },
            minio: {
                accessKey: MINIO_ACCESS_KEY,
                endPoint: MINIO_NAMESPACE && MINIO_NAMESPACE.length > 0
                    ? MINIO_HOST + "." + MINIO_NAMESPACE
                    : MINIO_HOST,
                port: parseInt(MINIO_PORT, 10),
                secretKey: MINIO_SECRET_KEY,
                useSSL: asBool(MINIO_SSL),
            },
            proxy: artifacts_1.loadArtifactsProxyConfig(env),
            streamLogsFromServerApi: asBool(STREAM_LOGS_FROM_SERVER_API),
            allowedDomain: ALLOWED_ARTIFACT_DOMAIN_REGEX,
        },
        metadata: {
            envoyService: {
                host: METADATA_ENVOY_SERVICE_SERVICE_HOST,
                port: METADATA_ENVOY_SERVICE_SERVICE_PORT,
            },
        },
        pipeline: {
            host: ML_PIPELINE_SERVICE_HOST,
            port: ML_PIPELINE_SERVICE_PORT,
        },
        server: {
            apiVersion1Prefix: exports.apiVersion1Prefix,
            apiVersion2Prefix: exports.apiVersion2Prefix,
            basePath: exports.BASEPATH,
            deployment: DEPLOYMENT_STR.toUpperCase() === Deployments.KUBEFLOW
                ? Deployments.KUBEFLOW
                : DEPLOYMENT_STR.toUpperCase() === Deployments.MARKETPLACE
                    ? Deployments.MARKETPLACE
                    : Deployments.NOT_SPECIFIED,
            hideSideNav: HIDE_SIDENAV === undefined
                ? DEPLOYMENT_STR.toUpperCase() === Deployments.KUBEFLOW
                : asBool(HIDE_SIDENAV),
            port: port,
            staticDir: staticDir,
        },
        viewer: {
            tensorboard: {
                podTemplateSpec: utils_1.loadJSON(VIEWER_TENSORBOARD_POD_TEMPLATE_SPEC_PATH),
                tfImageName: VIEWER_TENSORBOARD_TF_IMAGE_NAME,
            },
        },
        visualizations: {
            allowCustomVisualizations: asBool(ALLOW_CUSTOM_VISUALIZATIONS),
        },
        gkeMetadata: {
            disabled: asBool(DISABLE_GKE_METADATA),
        },
        auth: {
            enabled: asBool(ENABLE_AUTHZ),
            kubeflowUserIdHeader: KUBEFLOW_USERID_HEADER,
            kubeflowUserIdPrefix: KUBEFLOW_USERID_PREFIX,
        },
    };
}
exports.loadConfigs = loadConfigs;
//# sourceMappingURL=configs.js.map