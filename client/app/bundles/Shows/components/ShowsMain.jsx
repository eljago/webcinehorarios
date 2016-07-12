import React, { PropTypes } from 'react';
import {Table, Button} from 'react-bootstrap'

// Simple example of a React "smart" component
export default class ShowsMain extends React.Component {
  static propTypes = {
    shows: PropTypes.object.isRequired,
    handleEdit: PropTypes.func.isRequired
  };

  render() {
    const tableRows = this.props.shows.map((show) => {
      return(
        <tr>
          <td>{show.get('id')}</td>
          <td>{show.get('name')}</td>
          <td><Button onClick={() => this.props.handleEdit(show)}>Editar</Button></td>
        </tr>
      );
    });

    return (
      <Table responsive>
        <thead>
          <tr>
            <th>id</th>
            <th>Nombre</th>
          </tr>
        </thead>
        <tbody>
          {tableRows}
        </tbody>
      </Table>
    );
  }
}
