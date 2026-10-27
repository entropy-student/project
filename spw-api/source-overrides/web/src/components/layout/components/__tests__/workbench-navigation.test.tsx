/*
Copyright (C) 2023-2026 QuantumNous

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.

For commercial licensing, please contact support@quantumnous.com
*/
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import type { ReactNode } from 'react'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import { AppSidebar } from '../app-sidebar'

const state = vi.hoisted(() => ({
  href: '/keys',
  mobile: false,
  collapsed: false,
  nested: false,
  admin: true,
  setOpen: vi.fn(),
}))
vi.mock('@tanstack/react-router', () => ({ useLocation: () => state.href }))
vi.mock('@/context/layout-provider', () => ({
  useLayout: () => ({ collapsible: 'icon', variant: 'inset' }),
}))
vi.mock('@/hooks/use-sidebar-view', () => ({
  useSidebarView: () => ({
    key: state.nested ? 'settings' : 'root',
    view: state.nested ? { id: 'settings' } : null,
    navGroups: [
      {
        id: 'general',
        title: 'General',
        items: [
          { title: 'API Keys', url: '/keys' },
          { title: 'Usage Logs', url: '/usage-logs/common' },
        ],
      },
      {
        id: 'personal',
        title: 'Personal',
        items: [{ title: 'Wallet', url: '/wallet' }],
      },
      ...(state.admin
        ? [
            {
              id: 'admin',
              title: 'Admin',
              items: [{ title: 'Channels', url: '/channels' }],
            },
          ]
        : []),
      { id: 'empty', title: 'Empty', items: [] },
    ],
  }),
}))
vi.mock('@/components/ui/sidebar', () => ({
  Sidebar: (props: { children: ReactNode }) => <aside>{props.children}</aside>,
  SidebarContent: (props: { children: ReactNode }) => (
    <div>{props.children}</div>
  ),
  SidebarRail: () => null,
  useSidebar: () => ({
    isMobile: state.mobile,
    state: state.collapsed ? 'collapsed' : 'expanded',
    setOpen: state.setOpen,
  }),
}))
vi.mock('../nav-group', () => ({
  NavGroup: (props: { items: Array<{ title: string; url: string }> }) => (
    <div>
      {props.items.map((item) => (
        <a key={item.url} href={item.url}>
          {item.title}
        </a>
      ))}
    </div>
  ),
}))
vi.mock('../sidebar-view-header', () => ({
  SidebarViewHeader: () => <span>Back to Dashboard</span>,
}))

beforeEach(() => {
  state.href = '/keys'
  state.mobile = false
  state.collapsed = false
  state.nested = false
  state.admin = true
  state.setOpen.mockClear()
})

describe('workbench navigation', () => {
  it('opens the current route group and lets the user inspect another group without navigating', async () => {
    const user = userEvent.setup()
    render(<AppSidebar />)
    expect(screen.getByRole('button', { name: 'Workspace' })).toHaveAttribute(
      'aria-pressed',
      'true'
    )
    expect(screen.getByRole('link', { name: 'API Keys' })).toHaveAttribute(
      'href',
      '/keys'
    )
    expect(
      screen.queryByRole('link', { name: 'Wallet' })
    ).not.toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: 'Personal' }))
    expect(await screen.findByRole('link', { name: 'Wallet' })).toHaveAttribute(
      'href',
      '/wallet'
    )
    expect(state.href).toBe('/keys')
  })
  it('follows a route change rather than retaining a previously inspected group', async () => {
    const user = userEvent.setup()
    const view = render(<AppSidebar />)
    await user.click(screen.getByRole('button', { name: 'Personal' }))
    await screen.findByRole('link', { name: 'Wallet' })
    state.href = '/channels'
    view.rerender(<AppSidebar />)
    expect(screen.getByRole('button', { name: 'Admin' })).toHaveAttribute(
      'aria-pressed',
      'true'
    )
    expect(await screen.findByRole('link', { name: 'Channels' })).toBeVisible()
  })
  it('renders only permission-filtered nonempty groups and expands the contextual menu from icon mode', async () => {
    const user = userEvent.setup()
    state.admin = false
    state.collapsed = true
    render(<AppSidebar />)
    expect(
      screen.queryByRole('button', { name: 'Admin' })
    ).not.toBeInTheDocument()
    expect(
      screen.queryByRole('button', { name: 'Empty' })
    ).not.toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: 'Personal' }))
    expect(state.setOpen).toHaveBeenCalledWith(true)
    expect(await screen.findByRole('link', { name: 'Wallet' })).toBeVisible()
  })
  it('keeps all permitted destinations directly accessible in the mobile drawer', () => {
    state.mobile = true
    state.admin = false
    render(<AppSidebar />)
    expect(
      screen.queryByRole('button', { name: 'Workspace' })
    ).not.toBeInTheDocument()
    expect(screen.getByRole('link', { name: 'API Keys' })).toBeVisible()
    expect(screen.getByRole('link', { name: 'Wallet' })).toBeVisible()
    expect(
      screen.queryByRole('link', { name: 'Channels' })
    ).not.toBeInTheDocument()
  })
  it('retains the contextual settings sidebar and its back affordance', () => {
    state.nested = true
    render(<AppSidebar />)
    expect(screen.getByText('Back to Dashboard')).toBeVisible()
    expect(
      screen.queryByRole('button', { name: 'Workspace' })
    ).not.toBeInTheDocument()
  })
})
