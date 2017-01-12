require 'jar_dependencies'
JBUNDLER_LOCAL_REPO = Jars.home
JBUNDLER_JRUBY_CLASSPATH = []
JBUNDLER_JRUBY_CLASSPATH.freeze
JBUNDLER_TEST_CLASSPATH = []
JBUNDLER_TEST_CLASSPATH.freeze
JBUNDLER_CLASSPATH = []
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/javassist/javassist/3.19.0-GA/javassist-3.19.0-GA.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/io/netty/netty-handler/4.1.5.Final/netty-handler-4.1.5.Final.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/google/guava/guava/19.0/guava-19.0.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/io/netty/netty-transport-native-epoll/4.1.5.Final/netty-transport-native-epoll-4.1.5.Final-linux-x86_64.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/bouncycastle/bcpkix-jdk15on/1.55/bcpkix-jdk15on-1.55.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/github/ben-manes/caffeine/caffeine/2.3.1/caffeine-2.3.1.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/fasterxml/jackson/datatype/jackson-datatype-jdk8/2.7.5/jackson-datatype-jdk8-2.7.5.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/bouncycastle/bcprov-jdk15on/1.55/bcprov-jdk15on-1.55.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/fasterxml/jackson/core/jackson-databind/2.7.3/jackson-databind-2.7.3.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/io/ratpack/ratpack-core/1.4.4/ratpack-core-1.4.4.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/io/netty/netty-transport/4.1.5.Final/netty-transport-4.1.5.Final.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/io/netty/netty-codec-http/4.1.5.Final/netty-codec-http-4.1.5.Final.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/io/netty/netty-codec/4.1.5.Final/netty-codec-4.1.5.Final.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/slf4j/slf4j-api/1.7.21/slf4j-api-1.7.21.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/fasterxml/jackson/dataformat/jackson-dataformat-yaml/2.7.5/jackson-dataformat-yaml-2.7.5.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/yaml/snakeyaml/1.15/snakeyaml-1.15.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/io/netty/netty-common/4.1.5.Final/netty-common-4.1.5.Final.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/slf4j/slf4j-simple/1.7.10/slf4j-simple-1.7.10.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/reactivestreams/reactive-streams/1.0.0/reactive-streams-1.0.0.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/io/netty/netty-buffer/4.1.5.Final/netty-buffer-4.1.5.Final.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/fasterxml/jackson/datatype/jackson-datatype-guava/2.7.5/jackson-datatype-guava-2.7.5.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/fasterxml/jackson/datatype/jackson-datatype-jsr310/2.7.5/jackson-datatype-jsr310-2.7.5.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/fasterxml/jackson/core/jackson-annotations/2.7.3/jackson-annotations-2.7.3.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/fasterxml/jackson/module/jackson-module-afterburner/2.7.3/jackson-module-afterburner-2.7.3.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/io/netty/netty-resolver/4.1.5.Final/netty-resolver-4.1.5.Final.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/fasterxml/jackson/core/jackson-core/2.7.3/jackson-core-2.7.3.jar')
JBUNDLER_CLASSPATH.freeze
