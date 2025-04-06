package studyCj
import hamster_commander_toolkit.*
import studyCj.services.*
import studyCj.model.History
public class Commander {
    
    public Commander (
        private let secretStore: SecretStore, 
        private let historyStore: IHistoryStore,
        private let commandService: ICommandService){
        }

    public func generateCommand(intent: String): String {
        // let apiKey = secretStore.get(API_KEY_KEY);
        // let apiSecret = secretStore.get(API_SECRET_KEY);
        // if (apiKey.isNone() || apiSecret.isNone()) {
        //     return "echo apiKey or apiSecret is not set";
        // }
        
        // let response = SparkCommandGenerator(apiKey.getOrThrow(), apiSecret.getOrThrow()).generateCommand(intent);

        let command = commandService.generateCommand(intent);

        historyStore.append(intent, command);
        return command;
    }
    
    public func setKeySecret(key: String,  secret: String) {
        secretStore.set(API_KEY_KEY, key);
        secretStore.set(API_SECRET_KEY, secret);
    }

    public func listHistory () {
        historyStore.list();
    }
    public func getHistory (id: Int64) {
        historyStore.get(id)
    }
    public func removeHistory (id: Int64) {
        historyStore.remove(id)
    }
}