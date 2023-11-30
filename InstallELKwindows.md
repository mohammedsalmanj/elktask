# Setting Up Elasticsearch and Kibana with Chocolatey

## Prerequisites

- Ensure that Chocolatey is installed on your machine. If not, you can install it by following the instructions on the [Chocolatey website](https://chocolatey.org/install).

## Install JDK, Elasticsearch, and Kibana using Chocolatey

1. **Install JDK:**
    ```
    choco install adoptopenjdk8
    ```

2. **Install Elasticsearch:**
    ```
    choco install elasticsearch --version=7.10.0
    ```

3. **Install Kibana:**
    ```
    choco install kibana --version=7.10.0
    ```

## Configure Elasticsearch and Kibana

1. **Navigate to Elasticsearch Config:**
    ```
    cd C:\ProgramData\chocolatey\lib\elasticsearch\tools\elasticsearch-7.10.0\config
    ```

2. **Edit `elasticsearch.yml`:**
    - Open `elasticsearch.yml` in a text editor.
    - Update `http.port` to `9200` (or your desired port).

3. **Navigate to Kibana Config:**
    ```
    cd C:\ProgramData\chocolatey\lib\kibana\tools\kibana-7.10.0-windows-x86_64\config
    ```

4. **Edit `kibana.yml`:**
    - Open `kibana.yml` in a text editor.
    - Update `server.port` to `5601` (or your desired port).
    - Update `elasticsearch.hosts` to point to your Elasticsearch instance.

## Start Elasticsearch and Kibana

1. **Start Elasticsearch:**
    - Open Command Prompt.
    - Navigate to the Elasticsearch bin directory:
        ```
        cd C:\ProgramData\chocolatey\lib\elasticsearch\tools\elasticsearch-7.10.0\bin
        ```
    - Run Elasticsearch:
        ```
        elasticsearch.bat
        ```

2. **Start Kibana:**
    - Open Command Prompt.
    - Navigate to the Kibana bin directory:
        ```
        cd C:\ProgramData\chocolatey\lib\kibana\tools\kibana-7.10.0-windows-x86_64\bin
        ```
    - Run Kibana:
        ```
        kibana.bat
        ```

## Accessing Elasticsearch and Kibana

- Elasticsearch: [http://localhost:9200](http://localhost:9200)
- Kibana: [http://localhost:5601](http://localhost:5601)
