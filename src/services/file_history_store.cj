package studyCj.services
import studyCj.model.*
import std.fs.*
import std.env.*
import encoding.json.stream.*
import std.io.*
import std.sync.*

public class FileHistoryStore<: IHistoryStore {
    public static let historyFilePath: Path;
    private let lock = ReentrantMutex();

    static init () {
        let historyStorePath = getHomeDirectory().join(".hamster_commander").join("history.json");
        if (!exists(historyStorePath)) {
            Directory.create(historyStorePath, recursive: true);
        }
        historyFilePath = historyStorePath.join("history.json");
    }

    public func append(intent: String, command: String): Int64 {
        lock.lock();
        if (!exists(historyFilePath)) {
            let file = File(historyFilePath, OpenMode.Write);
            file.write("[]".toArray())
            file.close()
        }
        // 读取 json文件
        var historyFile = File(historyFilePath, OpenMode.ReadWrite);
        let historyFileReader = JsonReader(historyFile);
        // historyFileWrite.writeConfig = WriteConfig()
        try {
            var histories = historyFileReader.readValue<Array<History>>()
            println("数据：" + histories.toString())
            let his = History(intent, command)
            histories = histories.concat(his)
            // 删除原文件 创建新文件
            let newPath = historyFilePath.parent.join("history.json.bak")
            historyFile.close()
            remove(historyFilePath, recursive: true);
            historyFile = File(newPath, OpenMode.Write);
            let historyFileWrite = JsonWriter(historyFile);
            historyFileWrite.writeValue(histories);
            historyFileWrite.flush()
            historyFile.close()
            rename(newPath, to:historyFilePath)
            return his.id;

        } catch (e: Exception) {
            println("json解析失败: ${e.message}")
            return -1;
        } finally {
            historyFile.close()
            lock.unlock();
        }
    }
    public  func list(): Array<History> {
        // 读取 json文件
        let historyFile = File(historyFilePath, OpenMode.Read);
        let historyFileReader = JsonReader(historyFile);
        // historyFileWrite.writeConfig = WriteConfig()
        try {
            var histories = historyFileReader.readValue<Array<History>>()
            return histories

        } catch (e: Exception) {
            println("json解析失败: ${e.message}")
            return []
        } finally {
            historyFile.close()
        }
    }
    public func get(id: Int64): ?History {
        // 读取 json文件
        let historyFile = File(historyFilePath, OpenMode.ReadWrite);
        let historyFileReader = JsonReader(historyFile);
        // historyFileWrite.writeConfig = WriteConfig()
        try {
            let histories = historyFileReader.readValue<Array<History>>()
            for (item in histories) {
                if (item.id == id) {
                    return item;
                }
            }
            return None;

        } catch (e: Exception) {
            println("json解析失败: ${e.message}")
            return None;
        } finally {
            historyFile.close()
        }

    }
    public func remove(id: Int64): Unit {
        // 读取 json文件
        var historyFile = File(historyFilePath, OpenMode.ReadWrite);
        let historyFileReader = JsonReader(historyFile);
        try {
            var index = -1;
            let histories = historyFileReader.readValue<Array<History>>()
            for (item in 0..histories.size) {
                if (histories[item].id == id) {
                    index = item;
                    break;
                }
            }
            if (index == -1) {
                return;
            }
    
            let startArray = histories.clone(0..index)
            let endArray = histories.clone(Range(index + 1, histories.size, 1, true, false, true))
            let newHistories = startArray.concat(endArray)
            // 删除原文件 创建新文件
            let newPath = historyFilePath.parent.join("history.json.bak")
            historyFile.close()
            remove(historyFilePath, recursive: true);
            historyFile = File(newPath, OpenMode.Write);
            let historyFileWrite = JsonWriter(historyFile);
            historyFileWrite.writeValue(newHistories);
            historyFileWrite.flush()
            historyFile.close()
            rename(newPath, to:historyFilePath)

        } catch (e: Exception) {
            println("json解析失败: ${e.message}")
            return ;
        } finally {
            historyFile.close()
        }
    }
    // 测试使用
    public func clear () {
        var historyFile = File(historyFilePath, OpenMode.ReadWrite);

        try {
             // 删除原文件 创建新文件
            let newPath = historyFilePath.parent.join("history.json.bak")
            historyFile.close()
            remove(historyFilePath, recursive: true);
            historyFile = File(newPath, OpenMode.Write);
            historyFile.write("[]".toArray())
            historyFile.close()
            rename(newPath, to:historyFilePath)
        } catch (e: Exception) {
            println("json解析失败: ${e.message}")
            return ;
        } finally {
            historyFile.close()
        }
    }
}