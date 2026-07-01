(function () {
    const TAB_KEY = 'dp_browser_tab_active';
    const CHANNEL_NAME = 'dp_browser_session';

    if (sessionStorage.getItem(TAB_KEY) === '1') {
        return;
    }

    const channel = new BroadcastChannel(CHANNEL_NAME);
    let otherTabOpen = false;
    let finished = false;

    const complete = function (markTabActive) {
        if (finished) {
            return;
        }

        finished = true;
        channel.close();

        if (markTabActive) {
            sessionStorage.setItem(TAB_KEY, '1');
        }
    };

    channel.onmessage = function (event) {
        const data = event.data || {};

        if (data.type === 'ping') {
            otherTabOpen = true;
            channel.postMessage({ type: 'pong' });
        } else if (data.type === 'pong') {
            otherTabOpen = true;
        }
    };

    channel.postMessage({ type: 'ping' });

    window.setTimeout(function () {
        if (otherTabOpen) {
            complete(true);
            return;
        }

        fetch('api/browser_session_guard.php', {
            method: 'GET',
            credentials: 'same-origin',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
            },
        })
            .then(function (response) {
                return response.json();
            })
            .then(function (data) {
                if (data && data.logout) {
                    sessionStorage.removeItem(TAB_KEY);
                    window.location.replace('logout.php');
                    return;
                }

                complete(true);
            })
            .catch(function () {
                complete(true);
            });
    }, 150);
})();
