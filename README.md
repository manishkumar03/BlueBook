A book management app which allows users to fetch the book details by scanning the barcode with the rear camera on their iPhone. The book data is stored locally using Cloudant Sync and gets synced with a remote database on the IBM Cloud (Bluemix). The app is built using MVVM design pattern using SOLID principles. The functionality provided by the app includes:

* Scan the barcode with the rear camera and fetch the book details from ISBNDB.com
* Store the book details locally using Cloudant Sync (CDTDatastore), enabling offline use
* Sync book data with a remote Cloudant NoSQL database on IBM Cloud (Bluemix)
* REST API to access the book catalog over http
