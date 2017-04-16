
(function () {
	"use strict";

	var config = {
			/* define locations of mandatory javascript files.
			 */
			files: {
				JQUERY: 'jquery.1.9.1.min.js',
				/* JQUERY: 'jquery.js', */
				CANVAS: 'canvasjs.js',
				CANVAS_EXPORT: 'excanvas.js'
			},
			TIMEOUT: 5000 /* 5 seconds timout for loading images */
		},
		mapCLArguments,
		render,
		startServer = false,
		args,
		pick,
		SVG_DOCTYPE = '<?xml version=\"1.0" standalone=\"no\"?><!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">',
		dpiCorrection = 1.4,
		system = require('system'),
		fs = require('fs'),
		serverMode = false;

	pick = function () {
		var args = arguments, i, arg, length = args.length;
		for (i = 0; i < length; i += 1) {
			arg = args[i];
			if (arg !== undefined && arg !== null && arg !== 'null' && arg != '0') {
				return arg;
			}
		}
	};

	mapCLArguments = function () {
		var map = {},
			i,
			key;

		if (system.args.length < 1) {
			console.log('Commandline Usage: canvas-convert.js -infile URL -outfile filename -scale 2.5 -width 300 -constr Chart -callback callback.js');
			console.log(', or run PhantomJS as server: canvas-convert.js -host 127.0.0.1 -port 1234');
		}

		for (i = 0; i < system.args.length; i += 1) {
			if (system.args[i].charAt(0) === '-') {
				key = system.args[i].substr(1, i.length);
				if (key === 'infile' || key === 'callback' || key === 'dataoptions' || key === 'globaloptions' || key === 'customcode') {
					// get string from file
					try {
						map[key] = fs.read(system.args[i + 1]).replace(/^\s+/, '');
					} catch (e) {
						console.log('Error: cannot find file, ' + system.args[i + 1]);
						phantom.exit();
					}
				} else {
					map[key] = system.args[i + 1];
				}
			}
		}
		return map;
	};

	render = function (params, exitCallback) {

		var page = require('webpage').create(),
			messages = {},
			scaleAndClipPage,
			loadChart,
			createChart,
			input,
			constr,
			callback,
			width,
			output,
			outType,
			timer,
			renderSVG,
			convert,
			exit,
			interval,
            counter,
            imagesLoaded = false;

		messages.optionsParsed = 'Canvas.options.parsed';
		messages.callbackParsed = 'Canvas.cb.parsed';

		window.optionsParsed = false;
		window.callbackParsed = false;

		page.onConsoleMessage = function (msg) {
			console.log(msg);

			/*
			 * Ugly hack, but only way to get messages out of the 'page.evaluate()'
			 * sandbox. If any, please contribute with improvements on this!
			 */

			/* to check options or callback are properly parsed */
			if (msg === messages.optionsParsed) {
				window.optionsParsed = true;
			}

			if (msg === messages.callbackParsed) {
				window.callbackParsed = true;
			}
		};

		page.onAlert = function (msg) {
			console.log(msg);
		};


		exit = function (result) {
			if (serverMode) {
				//Calling page.close(), may stop the increasing heap allocation
				page.close();
			}
			exitCallback(result);
		};

		loadChart = function( string_in, outputType ) {

			try {

				var container, htmlout;

				$(document.body).css('margin', '0px');

				$(document.body).css('backgroundColor', 'white');

				container = $('<div>').appendTo(document.body);
				container.attr('id', 'chartContainer' );
				// var sizing = 'width: ' + width + 'px;';
				// $container.attr('style', sizing );
				//console.log(" json_in: " + JSON.parse(json_in) );
				var json_in = JSON.parse(string_in);
				//json_in = JSON.parse(json_in);
				json_in["animationEnabled"] = false;

				//console.log ("just before canvas rendering");

				var chartTest = new CanvasJS.Chart("chartContainer", json_in );
				console.log ("complete the object create");

				var rs = chartTest.render();
				console.log ("completed the rendering");

				var htmlout = $('.canvasjs-chart-canvas')[0];
				//var imageData = htmlout.toDataURL(outType, 0.92 );
				var imageData = htmlout.toDataURL('image/'+outputType, 0.92 );
			} catch (e) {
				console.log('ERROR: Cannot create CanvasJS object.');
				console.log('Error message: ' + e.number + " - " + e.message)
				return { html: "<p>Error output</p>" };
			}
			return {
				html: imageData
			};
		};


		if (params.length < 1) {
			exit("Error: Insufficient parameters");
		} else {
			input = params.infile;
			output = params.outfile;
			console.log("input: " + input);
			console.log("output: " + output);

			if (output !== undefined) {
				outType = pick(output.split('.').pop(),'png');
			} else {
				outType = pick(params.type,'png');
			}

			constr = pick(params.constr, 'Chart');
			callback = params.callback;
			width = params.width;

			if (input === undefined || input.length === 0) {
				exit('Error: Insuficient or wrong parameters for rendering');
			}

			page.open('about:blank', function (status) {
				var svg,
					globalOptions = params.globaloptions,
					dataOptions = params.dataoptions,
					customCode = 'function customCode(options) {\n' + params.customcode + '}\n',
					jsfile;

				// load necessary libraries
				for (jsfile in config.files) {
					if (config.files.hasOwnProperty(jsfile)) {
						page.injectJs(config.files[jsfile]);
						//console.log("injecting: " + config.files[jsfile] );
					}
				}

				var rs = page.evaluate(loadChart, input, outType );

				try {
					var result = rs["html"].split(",")
					var result_blob = window.atob(result[1])
					var imageFile = fs.open(params.outfile, "wb");
					imageFile.write(result_blob);
					imageFile.close();
				} catch (e) {
					console.log("error evaluating document object. error: " + e.message);
				}

				// return the tmp file name and path to the calling process
				exit(params.outfile)

			});
		}
	};

	startServer = function (host, port) {
		var server = require('webserver').create();

		server.listen(host + ':' + port,
			function (request, response) {
				var jsonStr = request.postRaw || request.post,
					params,
					msg;
				try {
					params = JSON.parse(jsonStr);
					if (params.status) {
						// for server health validation
						response.statusCode = 200;
						response.write('OK');
						response.close();
					} else {
						render(params, function (result) {
							response.statusCode = 200;
							response.write(result);
							response.close();
						});
					}
				} catch (e) {
					msg = "Failed rendering: \n" + e;
					response.statusCode = 500;
					response.setHeader('Content-Type', 'text/plain');
					response.setHeader('Content-Length', msg.length);
					response.write(msg);
					response.close();
				}
			}); // end server.listen

		// switch to serverMode
		serverMode = true;

		console.log("OK, PhantomJS is ready.");
	};

	args = mapCLArguments();

	//console.log("made it past the args mapper")
	//console.log("arguments: " + JSON.stringify(args));
	// set tmpDir, for output temporary files.
	if (args.tmpdir === undefined) {
		config.tmpDir = fs.workingDirectory + '/tmp';
	} else {
		config.tmpDir = args.tmpdir;
	}

	// exists tmpDir and is it writable?
	if (!fs.exists(config.tmpDir)) {
		try{
			fs.makeDirectory(config.tmpDir);
		} catch (e) {
			console.log('ERROR: Cannot create temp directory for ' + config.tmpDir);
		}
	}


	if (args.host !== undefined && args.port !== undefined) {
		startServer(args.host, args.port);
	} else {
		// presume commandline usage
		//console.log("calling the renderer");
		render(args, function (msg) {
			console.log(msg);
			phantom.exit();
		});
	}
}());
