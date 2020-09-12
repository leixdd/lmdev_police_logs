window.onload = function() {
    document.querySelector('#container').style.display = 'none'; 

    var eventCallback = {
        viewLogs: function(data) {
            if(data.on) {
                document.querySelector('#container').style.display = 'block'; 

                fetch(`https://${GetParentResourceName()}/getLogs`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({})
                    
                }).then(resp => resp.json()).then(resp => console.log(resp));

            }else {
                document.querySelector('#container').style.display = 'none'; 
            }
        },
        
        policeLogs: function(data) {
            var res = JSON.parse(data.result)

            var el = document.querySelector('#dataList');
            el.innerHTML = "";
            
            res = Array.isArray(res) ? res : [];
            
            res.map(function(d) {
                el.innerHTML +=  '<tr><td>' + d.NAME +'</td><td>' + d.item_name +'</td><td>' + d.quantity +'</td><td>' + new Date( d.created_at).toString() +'</td></tr>';
            })
        }
    };

    window.addEventListener('message', function(event) {
        eventCallback[event.data.action](event.data);
    });

    document.getElementById("btnexit").addEventListener("click", function(e) {
        fetch(`https://${GetParentResourceName()}/exit_logs`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({})
            
        }).then(resp => resp.json()).then(resp => console.log(resp));
    });
}
