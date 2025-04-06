package studyCj.test


import std.unittest.*
import std.unittest.testmacro.*
import std.fs.*
import studyCj.services.* 

@Test
public class FileHistoryStoreTest {

    @BeforeEach
    @AfterEach
    public func removeFiles () {
        removeIfExists(FileHistoryStore.historyFilePath, recursive: true)
    }

    @TestCase
    public func testAppend() {
        let fileHistoryStore = FileHistoryStore();
        let id1 = fileHistoryStore.append("intent1", "command1");
        let id2 = fileHistoryStore.append("intent2", "command2");
        let histories = fileHistoryStore.list();
        // @Expect(histories.size, 2);
        var i1 = -1;
        var i2 = -1;
        for (i in 0..histories.size) {
            if (histories[i].id == id1) {
                i1 = i;
            }
            if (histories[i].id == id2) {
                i2 = i;
            }
        }
        @Expect(i1 >= 0);
        @Expect(i2 >= 0);
        @Expect(histories[i1].intent, "intent1");
        @Expect(histories[i1].command, "command1");
        @Expect(histories[i2].intent, "intent2");
        @Expect(histories[i2].command, "command2");
        fileHistoryStore.clear();
    }
    @TestCase
    public func testRemove() {
        let fileHistoryStore = FileHistoryStore();
        let id1 = fileHistoryStore.append("intent1", "command1");
        let id2 = fileHistoryStore.append("intent2", "command2");
        fileHistoryStore.remove(id1);
        let histories = fileHistoryStore.list();
        @Expect(histories.size, 1);
        @Expect(histories[0].intent, "intent2");
        @Expect(histories[0].command, "command2");
        fileHistoryStore.clear();
    }
    @TestCase
    public func testGet() {
        let fileHistoryStore = FileHistoryStore();
        let id1 = fileHistoryStore.append("intent1", "command1");
        let id2 = fileHistoryStore.append("intent2", "command2");
        let history = fileHistoryStore.get(id1);
        @Expect(history.isSome());
        @Expect(history.getOrThrow().intent, "intent1");
        @Expect(history.getOrThrow().command, "command1");
        fileHistoryStore.clear();
    }
}