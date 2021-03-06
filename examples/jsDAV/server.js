/*
 * @package jsDAV
 * @subpackage DAV
 * @copyright Copyright(c) 2011 Ajax.org B.V. <info AT ajax.org>
 * @author Mike de Boer <info AT mikedeboer DOT nl>
 * @license http://github.com/mikedeboer/jsDAV/blob/master/LICENSE MIT License
 */

var jsDAV = require("./../../jsDAV/lib/jsdav"),
    jsDAV_Locks_Backend_FS = require("./../../jsDAV/lib/DAV/plugins/locks/fs");

jsDAV.debugMode = true;

jsDAV.createServer({
    node: __dirname + "/assets",
    locksBackend: new jsDAV_Locks_Backend_FS(__dirname + "/assets")
}, 8001);
