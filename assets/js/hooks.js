let epochNow = () => Math.floor((new Date).getTime() / 1000)
let pad = (number) => String(number).padStart(2, '0')
let post = (path, data) => {
    fetch(path, {
        method: "post",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
    })
}

module.exports = {
    Timer: {
        updated() {
            if (this.timestamp !== this.el.dataset.timestamp) {
                let start = epochNow()
                let timerElement = this.el
                let updateTimer = () => {
                    let now = epochNow()
                    let seconds = (now - start) % 60
                    let minutes = Math.floor((now - start) / 60)
                    timerElement.innerText = `${pad(minutes)}:${pad(seconds)}`
                }
                clearInterval(this.timerInterval)
                updateTimer()
                this.timestamp = this.el.dataset.timestamp
                this.timerInterval = setInterval(updateTimer, 1000)
            }
        }
    },
    RememberName: {
        mounted() {
            this.el.addEventListener("blur", e => {
                post("/__api/set_name", { name: this.el.value })
            })
        }
    }
}
