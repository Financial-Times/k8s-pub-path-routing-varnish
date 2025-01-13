vcl 4.0;

import dynamic;

# Dummy definitions as we're using dynamic backend declaration
backend default {
    .host = "localhost";
    .port = "8888";
}

sub vcl_init {
    new dynBackend = dynamic.director(port = "8080");
}

acl purge {
    "localhost";
}

sub vcl_recv {

    # allow PURGE from localhost
    if (req.method == "PURGE") {
        if (!client.ip ~ purge) {
            return(synth(405,"Not allowed."));
        }
        return (purge);
    }

    # healthcheck
    if (req.method == "GET" && req.url == "/status") {
           return(synth(200, "OK"));
    }

    if (req.url ~ "^\/content.*$") {
        set req.url = regsub(req.url, "content", "notify");
        set req.backend_hint = dynBackend.backend("cms-notifier");
    } 
    elif (req.url ~ "^\/video.*$") {
        set req.url = regsub(req.url, "video", "notify");
        set req.backend_hint = dynBackend.backend("cms-notifier");
    } 
    elif (req.url ~ "^\/metadata.*$") {
        set req.url = regsub(req.url, "metadata", "notify");
        set req.backend_hint = dynBackend.backend("cms-metadata-notifier");
    } 
    elif (req.url ~ "^\/smartlogic.*$") {
        set req.url = regsub(req.url, "smartlogic", "notify");
        set req.backend_hint = dynBackend.backend("smartlogic-notifier");
    }
    elif (req.url ~ "^\/locations-smartlogic.*$") {
            set req.url = regsub(req.url, "locations-smartlogic", "notify");
            set req.backend_hint = dynBackend.backend("locations-smartlogic-notifier");
    }
    elif (req.url ~ "^\/specialist-smartlogic.*$") {
            set req.url = regsub(req.url, "specialist-smartlogic", "notify");
            set req.backend_hint = dynBackend.backend("specialist-smartlogic-notifier");
    }
    elif (req.url ~ "^\/concept/.*$") {
            set req.backend_hint = dynBackend.backend("cm-generic-concept-transformer");
    }
    elif (req.url ~ "^\/draft-annotations\/content\/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\/annotations\/publish.*$") {
            set req.backend_hint = dynBackend.backend("draft-annotations-publisher");
    }
    elif (req.url ~ "^\/draft-annotations\/content.*$") {
            set req.backend_hint = dynBackend.backend("draft-annotations-publisher");
    }
    elif (req.url ~ "^\/__[\w-]*\/.*$") {
        # create a new backend dynamically to match the requested URL that will be looked up in the Kubernetes DNS.
        # For example calling the URL /__content-ingester/xyz will forward the request to the service content-ingester with the url /xyz
        set req.backend_hint = dynBackend.backend(regsub(req.url, "^\/__([\w-]*)\/.*$", "\1"));
        set req.url = regsub(req.url, "^\/__[\w-]*\/(.*)$", "/\1");
        set req.http.X-VarnishPassThrough = "true";
    } else {
         return(synth(404, "Path not found"));
    }

    return (pipe);
}
