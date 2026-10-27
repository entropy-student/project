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
import { Link } from '@tanstack/react-router'
import { ArrowRight, ChartNoAxesCombined, KeyRound, Layers } from 'lucide-react'
import {
  motion,
  useMotionValue,
  useReducedMotion,
  useSpring,
  useTransform,
} from 'motion/react'
import { useTranslation } from 'react-i18next'

import { Button } from '@/components/ui/button'

interface GlacierHomeProps {
  isAuthenticated: boolean
}

export function GlacierHome(props: GlacierHomeProps) {
  const { t } = useTranslation()
  const reducedMotion = useReducedMotion()
  const pointerX = useMotionValue(0)
  const pointerY = useMotionValue(0)
  const rotateX = useSpring(useTransform(pointerY, [-0.5, 0.5], [3, -3]), {
    stiffness: 110,
    damping: 24,
  })
  const rotateY = useSpring(useTransform(pointerX, [-0.5, 0.5], [-4, 4]), {
    stiffness: 110,
    damping: 24,
  })
  const glintX = useSpring(useTransform(pointerX, [-0.5, 0.5], [-160, 220]), {
    stiffness: 85,
    damping: 24,
  })

  return (
    <main className='spw-landing'>
      <section
        className='spw-hero spw-workbench-hero'
        aria-labelledby='spw-hero-title'
        onPointerMove={(event) => {
          if (reducedMotion || event.pointerType !== 'mouse') return
          const bounds = event.currentTarget.getBoundingClientRect()
          pointerX.set((event.clientX - bounds.left) / bounds.width - 0.5)
          pointerY.set((event.clientY - bounds.top) / bounds.height - 0.5)
        }}
        onPointerLeave={() => {
          pointerX.set(0)
          pointerY.set(0)
        }}
      >
        <motion.div
          className='spw-hero-art'
          aria-hidden='true'
          style={reducedMotion ? undefined : { rotateX, rotateY }}
        >
          <img
            src='/spw/glacier-hero.png'
            alt=''
            width={1672}
            height={941}
            fetchPriority='high'
          />
          <motion.span
            className='spw-glacier-glint'
            style={reducedMotion ? undefined : { x: glintX }}
          />
        </motion.div>
        <div className='spw-hero-content'>
          <div className='spw-hero-copy'>
            <h1 id='spw-hero-title'>
              <span>{t('Connect models.')}</span>
              <span>{t('Give ideas their shape.')}</span>
            </h1>
            <p>
              {t(
                'One AI API service. Bring model capabilities into your product.'
              )}
            </p>
            <Button
              className='spw-hero-action disabled:opacity-50'
              render={
                <Link to={props.isAuthenticated ? '/dashboard' : '/sign-up'} />
              }
            >
              {props.isAuthenticated ? t('Go to Dashboard') : t('Get Started')}
              <ArrowRight aria-hidden='true' />
            </Button>
          </div>
        </div>
        <nav className='spw-service-rail' aria-label={t('Explore SPW API')}>
          <Link to='/pricing' className='spw-service-link'>
            <Layers aria-hidden='true' />
            <span>
              <strong>{t('Discover models')}</strong>
              <small>
                {t('Find the right capability for your next idea.')}
              </small>
            </span>
            <ArrowRight aria-hidden='true' />
          </Link>
          <Link to='/keys' className='spw-service-link'>
            <KeyRound aria-hidden='true' />
            <span>
              <strong>{t('Manage API keys')}</strong>
              <small>{t('Your applications, connected and in control.')}</small>
            </span>
            <ArrowRight aria-hidden='true' />
          </Link>
          <Link to='/wallet' className='spw-service-link'>
            <ChartNoAxesCombined aria-hidden='true' />
            <span>
              <strong>{t('Usage and balance')}</strong>
              <small>{t('See what you use and what remains.')}</small>
            </span>
            <ArrowRight aria-hidden='true' />
          </Link>
        </nav>
      </section>
    </main>
  )
}
