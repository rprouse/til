# Local Azure Storage Development

When developing applications that use Azure Blob, Queue Storage, and Table
Storage, you can use the [Azurite](https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azurite)
storage emulator which supersedes the Azure Storage Emulator.

Azurite is installed with Visual Studio 2022, or it can be installed as an
extension to Visual Studio Code, through npm or run as a Docker Container.

When running, it listens on http://127.0.0.1:10000 for Blob storage,
http://127.0.0.1:10001 for Queue and http://127.0.0.1:10002 for Table.

## Installing and Running

### Visual Studio

```sh
"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\Extensions\Microsoft\Azure Storage Emulator\azurite.exe"
```

I also used the command line options `--skipApiVersionCheck` because my Storage
package used a slightly different protocol version and `--location D:\Data` to
save files to a known location on disk.

## NPM

```sh
npm install -g azurite
azurite --silent --location c:\azurite --debug c:\azurite\debug.log
```

### Docker

```sh
docker pull mcr.microsoft.com/azure-storage/azurite
docker run -p 10000:10000 -p 10001:10001 -p 10002:10002 \
    mcr.microsoft.com/azure-storage/azurite
```

## Connection Strings

You can simply set `UseDevelopmentStorage=true` in the application configuration.

```xml
<appSettings>
  <add key="StorageConnectionString" value="UseDevelopmentStorage=true" />
</appSettings>
```

## Viewing Files In Storage

You can use [Azure Storage Explorer](https://azure.microsoft.com/en-ca/products/storage/storage-explorer/)
to view items in storage in Azure or stored using the Azurite emulator.

```sh
winget install --id Microsoft.Azure.StorageExplorer
```
