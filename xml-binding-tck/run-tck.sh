#!/bin/bash -x

#
# Copyright (c) 2019, 2021 Oracle and/or its affiliates. All rights reserved.
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v. 2.0, which is available at
# http://www.eclipse.org/legal/epl-2.0.
#
# This Source Code may also be made available under the following Secondary
# Licenses when the conditions for such availability set forth in the
# Eclipse Public License v. 2.0 are satisfied: GNU General Public License,
# version 2 with the GNU Classpath Exception, which is available at
# https://www.gnu.org/software/classpath/license.html.
#
# SPDX-License-Identifier: EPL-2.0 OR GPL-2.0 WITH Classpath-exception-2.0

TCK_NAME=xml-binding-tck

# Set workspace relative to the location of the script
WORKSPACE="$( cd "$(dirname "$0")" ; pwd -P )"/target

PAYARA_HOME=$1

# If provided, set concurrent threads
if [ $# == 2 ]; then
  CONCURRENT_THREADS=$2
fi

sed -i "s#^finder=.*#finder=com.sun.javatest.finder.BinaryTestFinder -binary ${WORKSPACE}/${TCK_NAME}/tests/testsuite.jtd#g" ${WORKSPACE}/${TCK_NAME}/testsuite.jtt
sed -i "s#^jck.env.jaxb.classes.jaxbClasses=.*#jck.env.jaxb.classes.jaxbClasses=${PAYARA_HOME}/glassfish/modules/jakarta.xml.bind-api.jar ${PAYARA_HOME}/glassfish/modules/jaxb-osgi.jar ${PAYARA_HOME}/glassfish/modules/jersey-media-jaxb.jar ${PAYARA_HOME}/glassfish/modules/jakarta.activation-api.jar ${WORKSPACE}/checker.jar#g" ${WORKSPACE}/${TCK_NAME}/lib/javasoft-multiJVM.jti
sed -i "s#^jck.env.jaxb.testExecute.cmdAsFile=.*#jck.env.jaxb.testExecute.cmdAsFile=${JAVA_HOME}/bin/java#g" ${WORKSPACE}/${TCK_NAME}/lib/javasoft-multiJVM.jti
sed -i "s#^WORKDIR=.*#WORKDIR=${WORKSPACE}/${TCK_NAME}/batch-multiJVM/work/#g" ${WORKSPACE}/${TCK_NAME}/lib/javasoft-multiJVM.jti
sed -i "s#^TESTSUITE=.*#TESTSUITE=${WORKSPACE}/${TCK_NAME}/#g" ${WORKSPACE}/${TCK_NAME}/lib/javasoft-multiJVM.jti
sed -i "s#^jck.env.jaxb.testExecute.otherEnvVars=.*#jck.env.jaxb.testExecute.otherEnvVars=JAVA_HOME\=${JAVA_HOME} JAXB_HOME=${PAYARA_HOME}/glassfish#g" ${WORKSPACE}/${TCK_NAME}/lib/javasoft-multiJVM.jti

# If provided, set concurrent threads
if [ $# == 2 ]; then
  sed -i "s#^jck.concurrency.concurrency=.*#jck.concurrency.concurrency=${CONCURRENT_THREADS}#g" ${WORKSPACE}/${TCK_NAME}/lib/javasoft-multiJVM.jti
fi

cat ${WORKSPACE}/${TCK_NAME}/lib/javasoft-multiJVM.jti

cd ${WORKSPACE}

echo "PAYARA_HOME=${PAYARA_HOME}"
echo "ANT_HOME=$ANT_HOME"
echo "JAVA_HOME=$JAVA_HOME"
echo "MAVEN_HOME=$MAVEN_HOME"
echo "PATH=$PATH"

#export TCK_ROOT=${WORKSPACE}
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"

wget --progress=bar:force --no-cache https://repo1.maven.org/maven2/org/checkerframework/checker/3.5.0/checker-3.5.0.jar -O ${WORKSPACE}/checker.jar

mkdir -p JAXB_REPORT/JAXB-TCK

cd ${TCK_NAME}/tests/api/signaturetest

java -jar ${WORKSPACE}/${TCK_NAME}/lib/javatest.jar -batch -testsuite ${WORKSPACE}/${TCK_NAME} -open ${WORKSPACE}/${TCK_NAME}/lib/javasoft-multiJVM.jti -workdir -create ${WORKSPACE}/batch-multiJVM/work -set jck.env.jaxb.xsd_compiler.skipValidationOptional Yes -set jck.env.jaxb.xsd_compiler.testCompile.xjcCmd "/bin/sh ${WORKSPACE}/${TCK_NAME}/linux/bin/xjc.sh" -set jck.env.jaxb.schemagen.run.jxcCmd "/bin/sh ${WORKSPACE}/${TCK_NAME}/linux/bin/schemagen.sh" -set jck.env.jaxb.testExecute.otherEnvVars "JAVA_HOME=${JAVA_HOME} JAXB_HOME=${PAYARA_HOME}/glassfish" -set jck.env.jaxb.classes.jaxbClasses "${PAYARA_HOME}/glassfish/modules/jakarta.xml.bind-api.jar ${PAYARA_HOME}/glassfish/modules/jaxb-osgi.jar ${PAYARA_HOME}/glassfish/modules/jersey-media-jaxb.jar ${PAYARA_HOME}/glassfish/modules/jakarta.activation-api.jar ${WORKSPACE}/checker.jar" -set jck.env.jaxb.classes.needJaxbClasses Yes -runtests
java -jar ${WORKSPACE}/${TCK_NAME}/lib/javatest.jar -batch -testsuite ${WORKSPACE}/${TCK_NAME} -open ${WORKSPACE}/${TCK_NAME}/lib/javasoft-multiJVM.jti -workdir ${WORKSPACE}/batch-multiJVM/work -set jck.env.jaxb.xsd_compiler.skipValidationOptional Yes -set jck.env.jaxb.xsd_compiler.testCompile.xjcCmd "/bin/sh ${WORKSPACE}/${TCK_NAME}/linux/bin/xjc.sh" -set jck.env.jaxb.schemagen.run.jxcCmd "/bin/sh ${WORKSPACE}/${TCK_NAME}/linux/bin/schemagen.sh" -set jck.env.jaxb.testExecute.otherEnvVars "JAVA_HOME=${JAVA_HOME} JAXB_HOME=${PAYARA_HOME}/glassfish" -set jck.env.jaxb.classes.jaxbClasses "${PAYARA_HOME}/glassfish/modules/jakarta.xml.bind-api.jar ${PAYARA_HOME}/glassfish/modules/jaxb-osgi.jar ${PAYARA_HOME}/glassfish/modules/jersey-media-jaxb.jar ${PAYARA_HOME}/glassfish/modules/jakarta.activation-api.jar ${WORKSPACE}/checker.jar" -set jck.env.jaxb.classes.needJaxbClasses Yes -set jck.priorStatus.needStatus Yes -set jck.priorStatus.status not_run -runtests

java -jar ${WORKSPACE}/${TCK_NAME}/lib/javatest.jar -workdir ${WORKSPACE}/batch-multiJVM/work -writereport ${WORKSPACE}/JAXB_REPORT/JAXB-TCK


export HOST=`hostname -f`
echo "1 JAXB-TCK ${HOST}" > ${WORKSPACE}/args.txt
mkdir -p ${WORKSPACE}/results/junitreports/
java -Djunit.embed.sysout=true -jar ${WORKSPACE}/../JTReportParser.jar ${WORKSPACE}/args.txt ${WORKSPACE}/JAXB_REPORT ${WORKSPACE}/results/junitreports/
rm -f ${WORKSPACE}/args.txt
cd ${WORKSPACE}
tar zcvf jaxbtck-results.tar.gz ${WORKSPACE}/JAXB_REPORT ${WORKSPACE}/batch-multiJVM/work ${WORKSPACE}/results/junitreports/
