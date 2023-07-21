(defproject devops-clojure-mini "0.0.1"
  :description "A mini"
  :url "http://github.com/Guaranteed-Rate/devops-clojure-mini"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :source-paths ["src"]
  :min-lein-version "2.9.1"
  :plugins [[s3-wagon-private/s3-wagon-private "1.3.4" :exclusions [commons-codec]]]
  :dependencies [[com.guaranteedrate/clj-elastic-apm "0.1.11"]
                 [org.clojure/clojure "1.10.1"]
                 [ring/ring-core "1.8.2"]
                 [ring/ring-devel "1.8.2"]
                 [ring/ring-jetty-adapter "1.8.2"]
                 [ring/ring-servlet "1.8.2"]]
  :repositories [["releases" {:url "s3p://polaris-maven/releases/"
                              :sign-releases false}]
                 ["snapshots" {:url "s3p://polaris-maven/snapshots/"}]]
  :main devops-clojure-mini.main
  :profiles
  {:repl 
   {:main devops-clojure-mini.main}

   :uberjar
    {:aot            [devops-clojure-mini.main]
     :resource-paths ["resources/uberjar"]
     :uberjar-name   "devops-clojure-mini.jar"}})
     