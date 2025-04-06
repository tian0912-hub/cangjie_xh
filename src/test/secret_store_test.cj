package studyCj.test

import std.unittest.*
import std.unittest.testmacro.*
import std.random.*
import std.fs.*
import studyCj.*


@Test
public class SecretStoreTest {
    @TestCase
    public func testSetGet() {
        let secureRandom = Random();
        
        let key = "key" + secureRandom.nextInt64().toString();
        let value = "value" + secureRandom.nextInt64().toString();

        let secretStore = SecretStore();
        secretStore.set(key, value);
        let result = secretStore.get(key);
        @Expect(result, Some(value));
        removeIfExists(secretStore.getSecretStoreFilePath(key));
    }
    
}