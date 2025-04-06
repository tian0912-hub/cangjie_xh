package studyCj.services
import studyCj.model.History
public interface IHistoryStore {
    func append(intent: String, command: String): Int64;
    func list(): Array<History>;
    func get(id: Int64): ?History;
    func remove(id: Int64): Unit;
}