# Jakarta XML Binding

## Prerequisites
Download and install the TCK from the tck-downloads module. From the top-level directory:

`mvn clean install -pl . -pl tck-download -pl tck-download/jakarta-xml-binding-tck -Dpayara.version=...`

## Test Executions
Run maven test from the top-level directory using managed arquillian profile

```
mvn clean verify -Ppayara-server-managed -Dpayara.version=...  -pl . -pl xml-binding-tck
```

By default this will run with a single thread. If you wish to run with more to speed up the TCK, add the 
`-Dconcurrent.threads=x` variable to the above command with your desired number of threads.

### Running the Script Directly
If you wish to run the `run-tck.sh` script directly, it is written with the following assumptions:
* It can take 0, 1, or 2 parameters
  * Parameter one must be the path of the Payara install you wish to test
    * If this is not provided, the script will assume the default managed arquillian location relative to the script (../target/payara7)
  * Paramter two must be the number of concurrent threads to use
    * If not provided, only 1 thread will be used
