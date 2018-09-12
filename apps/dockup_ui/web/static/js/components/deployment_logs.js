import React, { Component } from "react";

class DeploymentLogs extends Component {
  constructor(props) {
    super(props);
    this.state = { logs: [], scrolling: true, paginationId: 0 };
    this.onScroll = this.onScroll.bind(this);
    this.removeEventListener = this.removeEventListener.bind(this);
    this.fetchLogs = this.fetchLogs.bind(this);
  }

  componentDidMount() {
    this.fetchLogs();
    window.addEventListener("scroll", this.onScroll, false);
  }
  componentWillUnmount() {
    this.removeEventListener();
  }
  removeEventListener() {
    window.removeEventListener("scroll", this.onScroll, false);
  }
  onScroll() {
    if (window.innerHeight + window.scrollY >= document.body.offsetHeight) {
      this.fetchLogs();
    }
  }

  fetchLogs() {
    this.setState({ showLoading: "show" });
    fetch(`/api/logs/${this.props.containerId}?p=${this.state.paginationId}`)
      .then(response => {
        return response.json();
      })
      .then(json => {
        let logs = json.data;
        this.setState(prevState => {
          return {
            logs: [...prevState.logs, ...logs],
            paginationId: JSON.parse(logs[logs.length - 1].sort)[0],
            showLoading: "hide"
          };
        });
      })
      .catch(err => {
        this.setState(prevState => {
          return {
            logs: [
              ...prevState.logs,
              { log: "There was an error fetching the logs" }
            ],
            showLoading: "hide"
          };
        });
        this.removeEventListener();
      });
  }

  render() {
    return (
      <div>
        <div className="card">
          <div className="logs">
            {this.state.logs &&
              this.state.logs.map((data, index) => {
                return (
                  <div className="row logs_card" key={index}>
                    <div className="col-md-1 index">{index + 1}</div>
                    <div className="col-md-11">{data.log}</div>
                  </div>
                );
              })}
          </div>
        </div>
        <div className={this.state.showLoading}>
          <div className="row">
            <img src="/images/loading_gif.gif" className="col-md-2 images" />
          </div>
        </div>
      </div>
    );
  }
}

export default DeploymentLogs;
