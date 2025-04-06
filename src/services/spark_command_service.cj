package studyCj.services
import hamster_commander_toolkit.*

public class SparkCommandService<: ICommandService {
    public SparkCommandService(let secretStore: SecretStore){}
    public func generateCommand(intent: String): String {
        let apiKey = secretStore.get(API_KEY_KEY);
        let apiSecret = secretStore.get(API_SECRET_KEY);
        if (apiKey.isNone() || apiSecret.isNone()) {
            return "echo apiKey or apiSecret is not set";
        }
        let commandGenerator = SparkCommandGenerator(apiKey.getOrThrow(), apiSecret.getOrThrow());
        let command =commandGenerator.generateCommand(intent);
        return command;
    }
}