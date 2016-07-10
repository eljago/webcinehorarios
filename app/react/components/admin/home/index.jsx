import React from 'react'
import {Button} from 'react-bootstrap'

export default class HomeIndex extends React.Component {

  render () {
    return(
    	<div className="well" style={wellStyles}>
        <Button bsStyle="primary" bsSize="large" block>Block level button</Button>
        <Button bsSize="large" block>Block level button</Button>
      </div>
    );
  }
}

const wellStyles = {maxWidth: 400, margin: '0 auto 10px'};