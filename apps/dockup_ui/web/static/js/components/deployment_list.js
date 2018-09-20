import React, {Component} from 'react';
import DeploymentCard from './deployment_card';

class DeploymentList extends Component {
  constructor(props) {
    super(props);
    this.state = {
      filter: '',
      deployments: []
    }
    this.getDeployments();
    this.connectToDeploymentsChannel();
    this.handleChangeFilter = this.handleChangeFilter.bind(this);
  }

  getDeployments() {
    let xhr = new XMLHttpRequest();
    xhr.open('GET', '/api/deployments');
    xhr.onload = () => {
      if (xhr.status === 200) {
        let deployments = JSON.parse(xhr.responseText).data;
        this.setState({deployments});
      }
    };
    xhr.send();
  }

  addDeployment(deployment) {
    this.setState({deployments: [deployment, ...this.state.deployments]});
  }

  connectToDeploymentsChannel() {
    let channel = DockupUiSocket.getDeploymentsChannel();

    channel.on("status_updated", (deployment) => {
      let found = this.state.deployments.find(d => d.id == deployment.id);
      if (found) {
        this.updateDeployment(deployment);
      } else {
        this.addDeployment(deployment);
      }
    })

    channel.on("deployment_created", (deployment) => {
      this.addDeployment(deployment);
    })
  }

  updateDeployment(newDeployment) {
    let found = false;
    let newDeployments = this.state.deployments.map((deployment) => {
      if(deployment.id == newDeployment.id) {
        deployment = Object.assign({}, newDeployment);
        found = true;
      }
      return deployment;
    })

    if(found) {
      this.setState({deployments: newDeployments})
    }
  }

  handleChangeFilter(event) {
    this.setState({ filter: event.target.value });
  }

  renderDeployments() {
    const { filter, deployments } = this.state;
    return this.state.deployments
      .filter(({ status }) => status.includes(filter))
      .map((deployment) => (
      <DeploymentCard key={deployment.id} deployment={deployment}/>
    ));
  }

  render() {
    const deploymentLists = this.renderDeployments();

    return (
      <div className="container">
        <div className="c-list" style={{marginTop: 150 + 'px'}}>
          <h2 className="u-cl-purple">Total deployment: {deploymentLists.length}</h2>
          <select 
            value={this.state.filter}
            onChange={this.handleChangeFilter}
            className="c-select__input"
          >
            <option value="">All</option>
            <option value="started">Started</option>
            <option value="starting">Pending</option>
            <option value="deleted">Deleted</option>
          </select>
          <ul className="c-list--wrapper">
            {deploymentLists}
          </ul>
        </div>
      </div>
    )
  }
}

export default DeploymentList
