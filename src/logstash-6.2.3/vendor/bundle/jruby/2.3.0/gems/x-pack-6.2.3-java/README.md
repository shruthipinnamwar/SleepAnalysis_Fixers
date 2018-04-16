# Logstash x-pack

Set of plugins that form Logstash x-pack features. Currently, the only feature is monitoring.

# Setup
You must checkout x-pack-logstash and logstash with a specific directory structure. The
logstash checkout will be used when building x-pack. If you are building documentation,
you must also checkout logstash-docs. The structure is:

- /path/to/logstash
- /path/to/logstash-extra/x-pack-logstash
- /path/to/logstash-docs

```
$ ls $PATH_TO_REPOS
 ├── logstash
 ├── logstash-docs (Optional unless building documentation)
 └── logstash-extra
     └── x-pack-logstash
```

# Build

**Prerequisites**

Install JDK version 8. Make sure to set the JAVA_HOME environment variable to the path to your JDK installation directory. For example set JAVA_HOME=<JDK_PATH>
Install JRuby 9.1.x It is recommended to use a Ruby version manager such as RVM or rbenv.
Install rake and bundler tool using gem install rake and gem install bundler respectively.
RVM install (optional)

If you prefer to use rvm (ruby version manager) to manage Ruby versions on your machine, follow these directions:

```sh
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby=jruby-9.1.10.0
```
Check Ruby version

Before you proceed, please check your ruby version by:

```sh
$ ruby -v
jruby 9.1.10.0 (2.3.3) 2017-05-25 b09c48a Java HotSpot(TM) 64-Bit Server VM 25.131-b11 on 1.8.0_131-b11 +jit [darwin-x86_64]
```

---------------------------------------------------

To build a zip of Logstash x-pack, you can cd to `x-pack-logstash` and run:

```sh
gradle clean assemble
```

This will build a snapshot which is good for development purposes

To build a release version,

```sh
gradle clean assemble -Dbuild.snapshot=false
```

**Note:** If `xpack.logstash.build` is false, Logstash build step will be skipped.

# Build targets

The above build/assemble steps will create the plugin zip file in `build/distributions/x-pack-<version>.zip`
The gem file is already packaged inside this zip.

# PR testing and the target branch

If you happen to work on the Logstash x-pack when the build run the tests it will use a checkout repository of logstash, since all our product has aligned version and naming scheme the target branch of your PR will matter.

Examples:

If your PR on x-pack target the 5.x branch at test time it will checkout Logstash 5.x and run the tests.

If your PR on x-pack target the master branch at test time it will use the Logstash master branch.

If your PR on x-pack target a feature branch that exists on Logstash it will use that branch.

If your PR on x-pack target a feature branch that doesn't exist on Logstash it will use the master branch.

# Integration testing

The Logstash x-pack repository includes integration test with both *elasticsearch* and the *x-pack-elasticsearch* project, the integration task need to build
all the projects and require a strict directory structure to run successfully.

Expected directory structures:

```
elasticsearch/
elasticsearch-extra/x-pack-elasticsearch/
logstash-extra/x-pack-logstash/
logstash/
```

To run run the test you can use the following command:

```sh
gradle clean integTest
```

The tests are defined in `qa/integration` using rspec.

# Installing x-pack on Logstash binary

**Offline install:**

```sh
bin/logstash-plugin install file:///<dir>/distributions/x-pack-6.1.0-SNAPSHOT.zip
```

**Staging URL:**

```sh
LOGSTASH_PACK_URL="https://staging.elastic.co/<hash>/downloads/logstash-plugins" bin/logstash-plugin install x-pack
```

# Configuration

To configure x-pack settings, you can edit config/logstash.yml and add `xpack.*` configs

# Starting Logstash

Start Logstash with minimal config

```sh
bin/logstash -e 'input {stdin {}}'
```

If you want to start another LS instance, simply point your `path.data` to a new directory and start like above


# Building documentation

This repo contains information that is used in the Logstash Reference in 5.5 and later.

To build the Logstash Reference on your local machine, use the docbldls or docbldlsx build commands defined in https://github.com/elastic/docs/blob/master/doc_build_aliases.sh
