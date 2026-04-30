let connected = false;
let timerInterval;
let startTime;

const indicator = document.getElementById('statusIndicator');
const statusText = document.getElementById('statusText');
const connectBtn = document.getElementById('connectBtn');
const btnIcon = document.getElementById('btnIcon');
const btnText = document.getElementById('btnText');
const timeDiv = document.getElementById('connectionTime');
const ipAddress = document.getElementById('ipAddress');

async function updateStatus() {
    try {
        const res = await fetch('/api/status');
        const data = await res.json();
        
        if (data.connected) {
            indicator.classList.add('connected');
            statusText.textContent = 'Подключен';
            connectBtn.classList.add('connected');
            btnIcon.textContent = '🔒';
            btnText.textContent = 'Отключиться';
            connected = true;
            ipAddress.textContent = '185.147.80.5';
            timeDiv.style.display = 'block';
        } else {
            indicator.classList.remove('connected');
            statusText.textContent = 'Не подключен';
            connectBtn.classList.remove('connected');
            btnIcon.textContent = '🔓';
            btnText.textContent = 'Подключиться';
            connected = false;
            timeDiv.style.display = 'none';
            ipAddress.textContent = '-';
            clearInterval(timerInterval);
        }
    } catch (e) {
        console.error('Ошибка:', e);
    }
}

connectBtn.addEventListener('click', async () => {
    connectBtn.style.transform = 'scale(0.95)';
    setTimeout(() => {
        connectBtn.style.transform = '';
    }, 200);

    if (connected) {
        await fetch('/api/disconnect', { method: 'POST' });
        clearInterval(timerInterval);
    } else {
        startTime = new Date();
        await fetch('/api/connect', { method: 'POST' });
        
        clearInterval(timerInterval);
        timerInterval = setInterval(() => {
            const now = new Date();
            const diff = Math.floor((now - startTime) / 1000);
            const h = String(Math.floor(diff / 3600)).padStart(2, '0');
            const m = String(Math.floor((diff % 3600) / 60)).padStart(2, '0');
            const s = String(diff % 60).padStart(2, '0');
            document.getElementById('timeCounter').textContent = `${h}:${m}:${s}`;
        }, 1000);
    }
    
    setTimeout(updateStatus, 500);
});

// Первоначальная загрузка
updateStatus();
setInterval(updateStatus, 3000);
