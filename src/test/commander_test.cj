package studyCj.test

import std.unittest.*
import std.unittest.testmacro.*
import std.unittest.mock.*
import std.unittest.mock.mockmacro.*
import std.random.*
import studyCj.*
import studyCj.services.*
import studyCj.model.*

@Test
public class CommanderTest {

    @TestCase
    public func setKeySecret_default () {
        let random = Random();
        let randomInt16 = random.nextInt16();
        let key = "key" + randomInt16.toString();
        let secret = "secret" + randomInt16.toString();
        let secretStore = SecretStore();
        let historyStore = mock<IHistoryStore>();
        let commandService = mock<ICommandService>();
        let commander = Commander(secretStore, historyStore, commandService);
        commander.setKeySecret(key, secret);
        let keyFromSecretStore = secretStore.get(Commander.API_KEY_KEY);
        let secretFromSecretStore = secretStore.get(Commander.API_SECRET_KEY);
        @Expect(keyFromSecretStore, key);
        @Expect(secretFromSecretStore, secret);
    }

    @TestCase
    public func listHistory_defaulr () {
        let secretStore = SecretStore();
        let historyStore = mock<IHistoryStore>();
        let commandService = mock<ICommandService>();
        let historiesToReturn = [
            History("intent1", "command1"),
            History("intent2", "command2")
        ]
        @On(historyStore.list()).returns(historiesToReturn);

        let commander = Commander(secretStore, historyStore, commandService);

        let histories = commander.listHistory();
        @Expect(historiesToReturn.size, histories.size);
        for ( i in 0..histories.size ) {
            @Expect(refEq(historiesToReturn[i], histories[i]));
        }

    }


    @TestCase
    public func getHistory_defaulr () {
        let secretStore = SecretStore();
        let historyStore = mock<IHistoryStore>();
        let commandService = mock<ICommandService>();
        let historyToReturn = History("intent1", "command1")
        @On(historyStore.get(1)).returns(historyToReturn);

        let commander = Commander(secretStore, historyStore, commandService);

        let history = commander.getHistory(1);
        @Expect(history.isSome());
        @Expect(refEq(history.getOrThrow(), historyToReturn));

    }

    @TestCase
    public func removeHistory_defaulr () {
        let secretStore = SecretStore();
        let historyStore = mock<IHistoryStore>();
        let commandService = mock<ICommandService>();

        // 打桩
        @On(historyStore.remove(1)).returns();

        let commander = Commander(secretStore, historyStore, commandService);

        commander.removeHistory(1);
        // 验证调用了这个函数
        Verify.that(@Called(historyStore.remove(1)));

    }

    @TestCase
    public func generateCommand_defaulr () {
        let secretStore = SecretStore();
        let historyStore = mock<IHistoryStore>();
        let commandService = mock<ICommandService>();

        let intent = "intent1";
        let commandToReturn = "command1";

        @On(commandService.generateCommand(intent)).returns(commandToReturn);

        @On(historyStore.append(intent, commandToReturn)).returns(0);

        let commander = Commander(secretStore, historyStore, commandService);

        let command = commander.generateCommand(intent);
        @Expect(command, commandToReturn);
        Verify.that(@Called(historyStore.append(intent, commandToReturn)));
    }

   
}