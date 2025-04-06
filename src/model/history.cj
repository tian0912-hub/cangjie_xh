package studyCj.model
import encoding.json.stream.*
import std.io.{ByteBuffer, readToEnd}
import std.random.*

public class History <: JsonSerializable &JsonDeserializable<History> & ToString{
    // id
    // intent
    // command
    public var id: Int64 = 0;
    public History(public let intent: String, public let command: String) {
        id = Random().nextInt64()
    }

    public func toJson(w: JsonWriter): Unit {
        w.startObject();
        w.writeName("id").writeValue(id);
        w.writeName("intent").writeValue(intent);
        w.writeName("command").writeValue(command);
        w.endObject();
    }
    public static func fromJson(r: JsonReader): History {
        r.startObject();
        var id: Int64 = -1;
        var intent: String = "";
        var command: String = "";

        while (r.peek() != JsonToken.EndObject) {
            match (r.readName()) {
                case "id" => id = r.readValue<Int64>();
                case "intent" => intent = r.readValue<String>();
                case "command" => command = r.readValue<String>();
                case _ => r.skip();
            }
            
        }
        r.endObject()
        let history = History(intent, command);
        history.id = id;
        return history
    }

public func toString () {
    return "History(id: ${id}, intent: ${intent}, command: ${command})"
}
}