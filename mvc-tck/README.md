# Jakarta MVC TCK Runner

## Prerequisite

Download and install the TCK into your local Maven repo. 
From the top-level directory: `mvn clean install -pl . -pl tck-download -pl tck-download/jakarta-mvc-tck`

## Test Execution

To execute the full TCK against a managed Payara Server, execute from the top-level directory.

```
mvn clean verify -pl . -pl mvc-tck -Ppayara-server-managed
```

Remote profile is also supported, and can be run directly from the `mvc-tck` directory.
The TCK does not require any server-side configuration.