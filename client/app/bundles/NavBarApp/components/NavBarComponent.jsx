import React, { PropTypes } from 'react';
import {Nav, Navbar, NavDropdown, MenuItem, NavItem} from 'react-bootstrap'
import _ from 'lodash';

export default class NavBarComponent extends React.Component {
  static propTypes = {
    navBarItemsData: PropTypes.array
  };

  constructor(props) {
    super(props);
    _.bindAll(this, '_getNavBarItem');
  }

  render() {
    let navItems = [];
    const navBarItemsData = this.props.navBarItemsData;
    for (var i = 0; i < navBarItemsData.length; i++) {
      const itemData = navBarItemsData[i];
      const navBarItem = this._getNavBarItem(itemData);
      if (navBarItem) {
        navItems.push(navBarItem);
      }
    }

    return(
      <Navbar>
        {navItems}
      </Navbar>
    )
  }

  _getNavBarItem(itemData) {
    if (itemData.type === 'header') {
      return(
        <Navbar.Header>
          <Navbar.Brand>
            <a href={itemData.href}>{itemData.title}</a>
          </Navbar.Brand>
          <Navbar.Toggle />
        </Navbar.Header>
      );
    }
    else if (itemData.type === 'collapse') {
      let collapseItems = [];
      for (var i = 0; i < itemData.items.length; i++) {
        const collapseItem = this._getNavBarItem(itemData.items[i]);
        if (collapseItem) {collapseItems.push(collapseItem)}
      }
      if (collapseItems.length > 0) {
        return(
          <Navbar.Collapse>
            {collapseItems}
          </Navbar.Collapse>
        )
      }
    }
    else if (itemData.type === 'nav') {
      let navItems = [];
      for (var i = 0; i < itemData.items.length; i++) {
        const navItem = this._getNavBarItem(itemData.items[i]);
        if (navItem) {navItems.push(navItem)}
      }
      if (navItems.length > 0) {
        return(
          <Nav>
            {navItems}
          </Nav>
        )
      }
    }
    else if (itemData.type === 'dropdown') {
      let dropdownItems = [];
      for (var i = 0; i < itemData.items.length; i++) {
        const dropdownItem = this._getNavBarItem(itemData.items[i]);
        if (dropdownItem) {dropdownItems.push(dropdownItem)}
      }
      if (dropdownItems.length > 0) {
        return(
          <NavDropdown title={itemData.title} id={itemData.id}>
            {dropdownItems}
          </NavDropdown>
        )
      }
    }
    else if (itemData.type === 'nav_pull_right') {
      let navPullRightItems = [];
      for (var i = 0; i < itemData.items.length; i++) {
        const navPullRightItem = this._getNavBarItem(itemData.items[i]);
        if (navPullRightItem) {navPullRightItems.push(navPullRightItem)}
      }
      if (navPullRightItems.length > 0) {
        return(
          <Nav pullRight>
            {navPullRightItems}
          </Nav>
        )
      }
    }
    else if (itemData.type === 'nav_item') {
      return(
        <NavItem href={itemData.href}>{itemData.title}</NavItem>
      )
    }
    else if (itemData.type === 'menu_item') {
      return(
        <MenuItem href={itemData.href}>{itemData.title}</MenuItem>
      )
    }
    else if (itemData.type === 'divider') {
      return(
        <MenuItem divider />
      )
    }
    return null;
  }
}
