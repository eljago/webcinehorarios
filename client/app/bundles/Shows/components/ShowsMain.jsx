import React, { PropTypes } from 'react';
import {Button, Image, Grid, Row, Col} from 'react-bootstrap'

// Simple example of a React "smart" component
export default class ShowsMain extends React.Component {
  static propTypes = {
    shows: PropTypes.object.isRequired,
    handleEdit: PropTypes.func.isRequired
  };

  render() {
    const tableRows = this.props.shows.map((show) => {
      return(
        <Row>
          <Col xs={1} md={1} lg={1}>{show.get('id')}</Col>
          <Col xs={3} md={2} lg={2}><Image src={show.get('image').get('smallest').get('url')} /></Col>
          <Col xs={6} md={7} lg={7} fluid={true}>{show.get('name')}</Col>
          <Col xs={2} md={2} lg={2}><Button onClick={() => this.props.handleEdit(show)}>Editar</Button></Col>
        </Row>
      );
    });

    return (
      <Grid>
        {tableRows}
      </Grid>
    )
  }
}
