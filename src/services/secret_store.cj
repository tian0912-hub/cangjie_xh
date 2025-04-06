package studyCj.services

import std.env.*
import std.fs.*
import std.io.*
// import crypto.crypto.*

public class SecretStore {
    let secretStorePath = getHomeDirectory().join(".hamster_commander")
    let key = "hamster_commandr"
    let iv = "commanderhamster"
    // let sm4: SM4
    public init () {
        // sm4 = SM4(OperationMode.CBC ,key.toArray(), iv: iv.toArray())
    }
    public func getSecretStoreFilePath (key: String): Path {
        return secretStorePath.join(key);
    }
    public func set (key: String, value: String) {
        if (!exists(secretStorePath)) {
            Directory.create(secretStorePath);
        }
        let secretStoreFilePath = getSecretStoreFilePath(key);
        removeIfExists(secretStoreFilePath)
       
        try (
            secretStoreFile = File(secretStoreFilePath, OpenMode.Write),
            secretStoreFileWriter = StringWriter<File>(secretStoreFile)
        ){
            // secretStoreFile.write(sm4.encrypt(value.toArray()))
            secretStoreFileWriter.write(value)

        }
    }
    public func get (key: String): Option<String> {
        let secretStoreFilePath = getSecretStoreFilePath(key);
        if (!exists(secretStoreFilePath)) {
            return None
        };

        try (
            secretStoreFile = File(secretStoreFilePath, OpenMode.Read),
            secretStoreFileReader = StringReader<File>(secretStoreFile)){
            
            return Some(secretStoreFileReader.readToEnd())
            // return Some(String.fromUtf8(sm4.decrypt(secretStoreFile.readToEnd())))
        }
        return None;
    }

}