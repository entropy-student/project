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
import { useLocation } from '@tanstack/react-router'
import { Compass } from 'lucide-react'
import { AnimatePresence, motion, useReducedMotion } from 'motion/react'
import { useId, useState } from 'react'
import { useTranslation } from 'react-i18next'

import { Button } from '@/components/ui/button'
import {
  Sidebar,
  SidebarContent,
  SidebarRail,
  useSidebar,
} from '@/components/ui/sidebar'
import { useLayout } from '@/context/layout-provider'
import { useSidebarView } from '@/hooks/use-sidebar-view'
import { MOTION_TRANSITION, MOTION_VARIANTS } from '@/lib/motion'

import { checkIsActive } from '../lib/url-utils'
import { NavGroup } from './nav-group'
import { SidebarViewHeader } from './sidebar-view-header'

/**
 * Application sidebar.
 *
 * Adopts the Vercel / Cloudflare "drill-in" pattern: the URL drives
 * which sidebar *view* is rendered. Clicking a top-level entry like
 * `System Settings` swaps the sidebar to a contextual workspace —
 * with a `← Back to Dashboard` affordance — instead of stacking the
 * sub-navigation inside the root tree.
 *
 * Architecture:
 *   - View resolution + filtering: {@link useSidebarView}
 *   - View registry: `layout/lib/sidebar-view-registry.ts`
 *   - Per-view header: {@link SidebarViewHeader}
 *
 * Adding a new nested view only requires registering a {@link SidebarView}
 * in the registry; this component requires no changes.
 */
export function AppSidebar() {
  const { t } = useTranslation()
  const { collapsible, variant } = useLayout()
  const { key, view, navGroups } = useSidebarView()
  const shouldReduce = useReducedMotion()
  const { isMobile, state, setOpen } = useSidebar()
  const href = useLocation({ select: (location) => location.href })
  const panelId = useId()
  const [choice, setChoice] = useState<{ href: string; id: string } | null>(
    null
  )
  const groups = navGroups.filter((group) => group.items.length > 0)
  const routeGroup =
    groups.find((group) =>
      group.items.some((item) => checkIsActive(href, item, true))
    ) ??
    groups.find((group) => group.id === 'general') ??
    groups[0]
  const selectedGroup =
    (choice?.href === href
      ? groups.find((group) => (group.id ?? group.title) === choice.id)
      : null) ?? routeGroup

  if (!view && !isMobile) {
    return (
      <Sidebar
        collapsible={collapsible}
        variant={variant}
        className='spw-workbench-sidebar'
      >
        <div className='spw-navigation-shell'>
          <nav className='spw-navigation-rail' aria-label={t('Console')}>
            {groups.map((group) => {
              const selected = group === selectedGroup
              const Icon = group.items[0]?.icon ?? Compass
              const label =
                group.id === 'general' ? t('Workspace') : group.title
              return (
                <Button
                  key={group.id ?? group.title}
                  type='button'
                  variant='ghost'
                  className='spw-rail-button'
                  aria-label={label}
                  aria-pressed={selected}
                  aria-controls={panelId}
                  onClick={() => {
                    setChoice({ href, id: group.id ?? group.title })
                    if (state === 'collapsed') setOpen(true)
                  }}
                >
                  {selected && (
                    <motion.span
                      className='spw-rail-selection'
                      layoutId='spw-workbench-rail-selection'
                      initial={false}
                      transition={
                        shouldReduce
                          ? { duration: 0 }
                          : { type: 'spring', stiffness: 420, damping: 36 }
                      }
                    />
                  )}
                  <Icon aria-hidden='true' />
                  <span className='spw-rail-label'>{label}</span>
                </Button>
              )
            })}
          </nav>
          <div className='spw-module-navigation' id={panelId}>
            <div className='spw-module-heading'>
              {selectedGroup?.id === 'general'
                ? t('Workspace')
                : selectedGroup?.title}
            </div>
            <SidebarContent>
              <AnimatePresence mode='wait' initial={false}>
                <motion.div
                  key={selectedGroup?.id ?? selectedGroup?.title}
                  initial={shouldReduce ? false : { opacity: 0, x: 6 }}
                  animate={{ opacity: 1, x: 0 }}
                  exit={shouldReduce ? undefined : { opacity: 0, x: -6 }}
                  transition={{ duration: shouldReduce ? 0 : 0.16 }}
                >
                  {selectedGroup && <NavGroup {...selectedGroup} />}
                </motion.div>
              </AnimatePresence>
            </SidebarContent>
          </div>
        </div>
        <SidebarRail />
      </Sidebar>
    )
  }

  return (
    <Sidebar collapsible={collapsible} variant={variant}>
      {view && <SidebarViewHeader view={view} />}

      <SidebarContent className='py-2'>
        <AnimatePresence mode='wait' initial={false}>
          <motion.div
            key={key}
            initial={
              shouldReduce ? false : MOTION_VARIANTS.sidebarSlide.initial
            }
            animate={MOTION_VARIANTS.sidebarSlide.animate}
            exit={shouldReduce ? undefined : MOTION_VARIANTS.sidebarSlide.exit}
            transition={MOTION_TRANSITION.fast}
            className='flex flex-col'
          >
            {navGroups.map((props) => (
              <NavGroup key={props.id || props.title} {...props} />
            ))}
          </motion.div>
        </AnimatePresence>
      </SidebarContent>

      <SidebarRail />
    </Sidebar>
  )
}
