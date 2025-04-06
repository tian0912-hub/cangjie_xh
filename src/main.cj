package studyCj

import std.convert.Parsable

import hamster_commander_toolkit.*
import studyCj.services.*
import studyCj.model.*
main(args: Array<String>): Int64 {
    if (args.isEmpty()) {
        println("请告诉我你想做什么")
        return 0;
    }

    let secretStore = SecretStore();
    let historyStore = FileHistoryStore();
    let commandService = SparkCommandService(secretStore);
    let commander = Commander(secretStore, historyStore, commandService);
    
    let arg0 = args[0];
    match (arg0) {
        case "setKeySecret" where args.size == 3 => commander.setKeySecret(args[1], args[2]);
        case "setKeySecret" => println("echo '设置API KEY 和API Secret: cmdr setKeySecret <key> <secret>'");
        case "list" =>
           let history = commander.listHistory();
            for (i in 0..history.size) {
                println("ID: ${history[i].id}");
                println("Intent: ${history[i].intent}");
                println("Command: ${history[i].command}");
                println();
            }
        case "get" where args.size != 2 => println("echo '获取历史记录： cmdr get <id>")
        case "get" where args.size == 2 => 
            var h: ?History = None;
            try {
                h = commander.getHistory(Int64.parse(args[1]));
            } catch (_: Exception) {
                
            }
            if (let Some(history) <- h) {
                println(history.command);
            } else {
                println("echo '历史记录不存在'");
            }
        case "remove" where args.size != 2 => println("echo '删除历史记录： cmdr remove <id>")
        case "remove" where args.size == 2 => 
            try {
                commander.removeHistory(Int64.parse(args[1]));
            } catch (_: Exception) {
                
            }
        case _ => println(commander.generateCommand(arg0));
    }

    return 0
}
