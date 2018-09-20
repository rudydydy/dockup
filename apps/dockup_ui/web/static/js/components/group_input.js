import React, {Component} from 'react';
import {Typeahead} from 'react-bootstrap-typeahead';

class GroupInput extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange([url, ...rest]) {
    if(url) {
      this.props.onGroupChange(url);
    }
  }

  render() {
    return(
      <div className="c-form-control">
        <img className="c-form-icon" src="/icons/icon-git.svg" />
        <Typeahead
          onChange={this.handleChange}
          options={this.props.groups}
          placeholder="Groups"
        />
      </div>
    );
  }
}

export default GroupInput
