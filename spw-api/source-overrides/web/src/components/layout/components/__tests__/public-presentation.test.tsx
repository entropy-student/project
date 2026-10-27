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
import { render, renderHook, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import type { AnchorHTMLAttributes } from 'react'
import { beforeEach, describe, expect, it, vi } from 'vitest'

import { useTopNavLinks } from '@/hooks/use-top-nav-links'

import { AppHeader } from '../app-header'
import { Footer } from '../footer'
import { PublicHeader } from '../public-header'

const state = vi.hoisted(() => ({
  footerHtml: '',
  pricingEnabled: true,
  authenticated: false,
}))
vi.mock('@tanstack/react-router', () => ({
  Link: ({
    to,
    disabled: _disabled,
    ...props
  }: AnchorHTMLAttributes<HTMLAnchorElement> & {
    to: string
    disabled?: boolean
  }) => <a {...props} href={to} />,
  useNavigate: () => vi.fn(),
  useRouterState: () => ({ location: { pathname: '/' } }),
  useLocation: () => '/keys',
}))
vi.mock('@/hooks/use-status', () => ({
  useStatus: () => ({
    status: {
      version: 'v1.0.0-rc.46',
      docs_link: 'https://docs.example.test',
      HeaderNavModules: JSON.stringify({
        home: true,
        console: true,
        pricing: { enabled: state.pricingEnabled, requireAuth: true },
        rankings: true,
        docs: true,
        about: true,
      }),
      user_agreement_enabled: true,
      privacy_policy_enabled: true,
    },
  }),
}))
vi.mock('@/hooks/use-system-config', () => ({
  useSystemConfig: () => ({
    systemName: 'SPW API',
    logo: '/spw/mark.svg',
    logoLoaded: true,
    loading: false,
    demoSiteEnabled: false,
    footerHtml: state.footerHtml,
  }),
}))
vi.mock('@/stores/auth-store', () => ({
  useAuthStore: () => ({
    auth: { user: state.authenticated ? { role: 100 } : null },
  }),
}))
vi.mock('@/hooks/use-notifications', () => ({ useNotifications: () => ({}) }))
vi.mock('@/hooks/use-sidebar-view', () => ({
  useSidebarView: () => ({
    navGroups: [{ items: [{ title: 'API Keys', url: '/keys' }] }],
  }),
}))
vi.mock('@/components/config-drawer', () => ({ ConfigDrawer: () => null }))
vi.mock('@/components/search', () => ({
  Search: () => <button type='button'>Search</button>,
}))
vi.mock('@/components/ui/sidebar', () => ({
  SidebarTrigger: () => <button type='button'>Toggle Sidebar</button>,
}))
vi.mock('@/components/dialog', () => ({ Dialog: () => null }))
vi.mock('@/components/language-switcher', () => ({
  LanguageSwitcher: () => null,
}))
vi.mock('@/components/notification-popover', () => ({
  NotificationPopover: () => null,
}))
vi.mock('@/components/profile-dropdown', () => ({
  ProfileDropdown: () => null,
}))
vi.mock('@/components/theme-switch', () => ({ ThemeSwitch: () => null }))
vi.mock('../header-logo', () => ({ HeaderLogo: () => <span>Logo</span> }))
vi.mock('@/features/system-update/system-update-action', () => ({
  SystemUpdateAction: () => <button type='button'>Update available</button>,
}))

beforeEach(() => {
  state.footerHtml = ''
  state.pricingEnabled = true
  state.authenticated = false
})

describe('SPW public navigation', () => {
  it('omits deferred modules even when enabled in dynamic configuration and keeps pricing access requirements', () => {
    const { result, rerender } = renderHook(() => useTopNavLinks())
    expect(result.current.map((link) => link.href)).toEqual([
      '/',
      '/dashboard',
      '/pricing',
    ])
    expect(
      result.current.find((link) => link.href === '/pricing')?.requiresAuth
    ).toBe(true)
    state.authenticated = true
    rerender()
    expect(
      result.current.find((link) => link.href === '/pricing')?.requiresAuth
    ).toBe(false)
    state.pricingEnabled = false
    rerender()
    expect(result.current.map((link) => link.href)).toEqual(['/', '/dashboard'])
  })

  it('keeps the closed mobile menu inert and exposes the same reduced navigation when opened', async () => {
    const user = userEvent.setup()
    const { container } = render(<PublicHeader />)
    const menu = container.querySelector('#spw-mobile-navigation')
    if (!menu) throw new Error('Mobile navigation must be present')
    expect(menu).toHaveAttribute('inert')
    const toggle = screen.getByRole('button', {
      name: 'Toggle navigation menu',
    })
    await user.click(toggle)
    expect(toggle).toHaveAttribute('aria-expanded', 'true')
    expect(menu).not.toHaveAttribute('inert')
    expect(
      [...menu.querySelectorAll('nav a')].map((link) =>
        link.getAttribute('href')
      )
    ).toEqual(['/', '/dashboard', '/pricing'])
    await user.click(toggle)
    expect(toggle).toHaveAttribute('aria-expanded', 'false')
    expect(menu).toHaveAttribute('inert')
  })

  it('does not advertise updates or a release version on the public header even to an administrator', () => {
    state.authenticated = true
    render(<PublicHeader />)
    expect(screen.queryByText('Update available')).not.toBeInTheDocument()
    expect(screen.queryByText('v1.0.0-rc.46')).not.toBeInTheDocument()
  })

  it('shows the current workspace context without public navigation or release prompts for an administrator', () => {
    state.authenticated = true
    render(<AppHeader />)
    expect(screen.getByText('API Keys')).toBeVisible()
    expect(screen.getByRole('button', { name: 'Search' })).toBeVisible()
    expect(screen.queryByText('Update available')).not.toBeInTheDocument()
    expect(screen.queryByText('v1.0.0-rc.46')).not.toBeInTheDocument()
    expect(
      screen.queryByRole('link', { name: 'Console' })
    ).not.toBeInTheDocument()
  })
})

describe('compact homepage footer', () => {
  it('retains legal links and upstream attribution without the promotional section', () => {
    render(<Footer compact />)
    expect(
      screen.getByRole('link', { name: 'User Agreement' })
    ).toHaveAttribute('href', '/user-agreement')
    expect(
      screen.getByRole('link', { name: 'Privacy Policy' })
    ).toHaveAttribute('href', '/privacy-policy')
    expect(screen.getByRole('link', { name: 'New API' })).toHaveAttribute(
      'href',
      'https://github.com/QuantumNous/new-api'
    )
    expect(
      screen.queryByText('Powerful API Management Platform')
    ).not.toBeInTheDocument()
  })

  it('honors administrator custom footer content even when compact is requested', () => {
    state.footerHtml = '<p>Custom support information</p>'
    render(<Footer compact />)
    expect(screen.getByText('Custom support information')).toBeInTheDocument()
    expect(screen.getByRole('link', { name: 'New API' })).toBeInTheDocument()
  })
})
