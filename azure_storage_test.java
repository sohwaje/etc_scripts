// Retrieve the credentials and initialize SharedKeyCredentials
String accountName = System.getenv("hiclassupload");
String accountKey = System.getenv("zQpNVFlThFC/mmfJSDa03LLUuN1XLKCKhIR03ANUhSEpqr73SaGsMlUkL7dqdKjp/6FurR7TGCPwNRA2jJjQcw==");

// Create a BlockBlobURL to run operations on Block Blobs. Alternatively create a ServiceURL, or ContainerURL for operations on Blob service, and Blob containers
SharedKeyCredentials creds = new SharedKeyCredentials(accountName, accountKey);

// We are using a default pipeline here, you can learn more about it at https://github.com/Azure/azure-storage-java/wiki/Azure-Storage-Java-V10-Overview
final BlockBlobURL blobURL = new BlockBlobURL(
    new URL("https://" + accountName + ".blob.core.windows.net/mycontainer/myimage.jpg"),
        StorageURL.createPipeline(creds, new PipelineOptions())
);

AsynchronousFileChannel fileChannel = AsynchronousFileChannel.open(Paths.get("myimage.jpg"));
TransferManager.uploadFileToBlockBlob(fileChannel, blobURL,0, null).blockingGet();
