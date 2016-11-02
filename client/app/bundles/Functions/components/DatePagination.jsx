'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import moment from 'moment'
import update from 'react/lib/update';

export default class DatePagination extends React.Component {

  static propTypes = {
    offsetDays: PropTypes.number,
    onChangeDay: PropTypes.func,
    disabled: PropTypes.boolean,
  };
  static defaultProps = {
    disabled: false,
  };

  constructor(props) {
    super(props);
    moment.locale('es-CL');
    this.state = {
      currentOffest: 0,
      selectedPillDate: this._getPrettyDateString(moment().add(props.offsetDays, 'days'))
    }
    _.bindAll(this, ['_onClickPrev', '_onClickNext'])
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      selectedPillDate: this._getPrettyDateString(moment().add(nextProps.offsetDays, 'days'))
    });
  }

  _getPrettyDateString(date) {
    return(_.upperFirst(date.format('ddd D')));
  }

  render() {
    let currDay = moment().add(this.state.currentOffest - 4, 'days');
    let dates = [this._getPrettyDateString(currDay)];
    for(let indx = 0; indx < 9; indx++) {
      dates.push(this._getPrettyDateString(currDay.add(1, 'days')));
    }
    // dates: ["Lun 17", "Mar 18", "Mier 19", etc...]

    const disabledClass = this.props.disabled ? {className: 'disabled'} : null;

    let navItems = [
      <li {...disabledClass}>
        <a href="#" aria-label="Previous" onClick={this._onClickPrev}>
          <span aria-hidden="true">&laquo;</span>
        </a>
      </li>,
      <li {...disabledClass}>
        <a href="#" aria-label="Next" onClick={this._onClickNext}>
          <span aria-hidden="true">&raquo;</span>
        </a>
      </li>
    ];

    const dateNavItems = dates.map((date, index) => {
      if (this.state.selectedPillDate === date) {
        return (
          <li className='active'>
            <a href="#" onClick={(e) => e.preventDefault()}>
              <span>{date}</span>
            </a>
          </li>
        );
      }
      else {
        return (
          <li {...disabledClass}>
            <a href="#" onClick={(e) => this._onClickDate(e, date, index)}>
              <span>{date}</span>
            </a>
          </li>
        );
      }
    });
    navItems = update(navItems, {$splice: [[1, 0, dateNavItems]]})

    return (
      <nav aria-label="Page navigation">
        <ul className="pagination pagination">
          {navItems}
        </ul>
      </nav>
    );
  }

  _onClickPrev(e) {
    this.setState({currentOffest: this.state.currentOffest - 1});
    e.preventDefault();
  }

  _onClickNext(e) {
    this.setState({currentOffest: this.state.currentOffest + 1});
    e.preventDefault();
  }

  _onClickDate(e, date, index) {
    this.setState({selectedPillDate: date});
    this.props.onChangeDay(this.state.currentOffest - 4 + index);
    e.preventDefault();
  }
}