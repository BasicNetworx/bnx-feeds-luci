'use strict';
'require fs';
'require rpc';
'require validation';


return L.view.extend({
        load: function() {
                return Promise.all([
			L.resolveDefault(fs.exec('/usr/sbin/bnx-sim-print-signal'), {})
                ]);
        },

	parseSimstatus: function(s) {
                var lines = s.trim().split(/\n/),
                    res = [];
		
                for (var i = 0; i < lines.length; i++) {
			var words = lines[i].split(",");
			var sim = words[0];			
			var status = words[1];			
			var type = words[2];			
			var signal = words[3];			
			var signal_val = words[4];
			var signal_disp = signal + " (" + signal_val + ")";

			var icon;
			if(signal == "Excellent") {
				icon = L.resource('icons/signal-75-100.png');
			} else if(signal == "Good") {
				icon = L.resource('icons/signal-50-75.png');
			} else if(signal == "Fair") {
				icon = L.resource('icons/signal-25-50.png');
			} else if(signal == "Poor") {
				icon = L.resource('icons/signal-0-25.png');
			} else {
				icon = L.resource('icons/signal-0.png');
			}			

			var signal_type;
			if(type.toUpperCase() == "LTE") {
				signal_type = type.toUpperCase() + " (4G) ";
			} else if (type.toUpperCase() == "WCDMA") {
				signal_type = type.toUpperCase() + " (3G) ";
			} else if (type.toUpperCase() == "GSM") {
				signal_type = type.toUpperCase() + " (2G) ";
			} else {
				signal_type = type;
			}

			res.push([
                                sim,
                                status,
                               	signal_type,
				signal_disp,
				E('img', { 'src': icon }),
                        ]);

                }

                return res;
        },

	render: function(data) {
                var simStatusOp= data[0].stdout || '';

                var simstatustbl = E('div', { 'class': 'table' }, [
                        E('div', { 'class': 'tr table-titles' }, [
                                E('div', { 'class': 'th' }, [ _('SIM-Interface') ]),
                                E('div', { 'class': 'th' }, [ _('SIM-Status') ]),
                                E('div', { 'class': 'th' }, [ _('Signal-Type') ]),
                                E('div', { 'class': 'th' }, [ _('Signal') ]),
                                E('div', { 'class': 'th' }, [ _('') ])
                        ])
                ]);

		cbi_update_table(simstatustbl, this.parseSimstatus(simStatusOp));

		return E([], [
                        E('h2', {}, [ _('SimStatus') ]),
			E('p', {}, [ _('The following tables will display current status of each sim') ]),

                        E('h3', {}, [ _(' ') ]),

                        simstatustbl
		]);
	},

	                                     
        handleSaveApply: null,                   
        handleSave: null,    
        handleReset: null

});
		
