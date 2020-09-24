let epochNow = () => Math.floor(new Date().getTime() / 1000)
let pad = (number) => String(number).padStart(2, "0")
let post = (path, data) => {
    fetch(path, {
        method: "post",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
    })
}

let start_clock = (hook) => {
    if (hook.el.dataset.timestamp !== "") {
        let start = parseInt(hook.el.dataset.timestamp)
        let timerElement = hook.el
        let updateClock = () => {
            let now = epochNow()
            let seconds = (now - start) % 60
            let minutes = Math.floor((now - start) / 60)
            timerElement.innerText = `${pad(minutes)}:${pad(seconds)}`
        }
        clearInterval(hook.timerInterval)
        updateClock()
        hook.timestamp = hook.el.dataset.timestamp
        hook.timerInterval = setInterval(updateClock, 1000)
    }
}

module.exports = {
    Timer: {
        mounted() {
            start_clock(this)
        },
        updated() {
            start_clock(this)
        }
    },
    RememberName: {
        mounted() {
            this.el.addEventListener("blur", (e) => {
                post("/__api/set_name", { name: this.el.value })
            })
        }
    }
}
