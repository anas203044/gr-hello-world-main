(ns devops-clojure-mini.main
  "A mini."
  (:require [clj-elastic-apm.core :as apm]
            [clojure.java.io :as io]
            [ring.adapter.jetty :as jetty]
            [clojure.data.json :as json]
            [ring.middleware.reload :refer [wrap-reload]])
  (:gen-class))


(defn initialize-apm []
  (let [settings {:server_urls          (or (System/getenv "ELASTIC_APM_SERVER_URL") "https://elastic-apm.dev.platform.rate.com")
                  :service_name         "devops-clojure-mini"
                  :environment          (or (System/getenv "ELASTIC_APM_ENVIRONMENT") "local")
                  :application_packages "devops_clojure_mini"}] ;underscore because of java
    (apm/initialize settings)))

(defn route-handler [{:keys [request-method uri body]}]
  (case [request-method uri]

    [:get "/"]
    {:status 200
     :headers {"Content-Type" "text/html"}
     :body (slurp (io/resource "html/index.html"))}

    [:get "/heartbeat"]
    {:status  200
     :headers {"Content-Type" "application/json"}
     :body    (json/write-str {"ok" true})}

    {:status 404
     :headers {"Content-Type" "text/html"}
     :body (slurp (io/resource "html/404.html"))}))

(def application
  (-> route-handler
      (apm/wrap-elastic-apm-route-tagging)
      (apm/wrap-elastic-apm-rum-injection)
      (apm/wrap-elastic-apm-transaction)))

(defn -main [& _]
  (initialize-apm)
  (let [ring-opts {:port 3000 :join? true}]
    (jetty/run-jetty (fn [req] (#'application req)) ring-opts)))

    