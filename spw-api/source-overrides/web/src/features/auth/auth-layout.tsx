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
import { useTranslation } from 'react-i18next'

import { Skeleton } from '@/components/ui/skeleton'
import { useSystemConfig } from '@/hooks/use-system-config'

type AuthLayoutProps = {
  children: React.ReactNode
}

export function AuthLayout(props: AuthLayoutProps) {
  const { t } = useTranslation()
  const { systemName, logo, loading } = useSystemConfig()

  return (
    <div className='bg-background relative grid min-h-svh lg:grid-cols-[minmax(0,0.8fr)_minmax(0,1.2fr)]'>
      <div
        aria-hidden='true'
        className='relative hidden overflow-hidden border-r lg:block'
      >
        <img
          src='/spw/glacier-hero.png'
          alt=''
          className='absolute inset-0 h-full w-full object-cover object-[65%_center]'
        />
      </div>
      <Link
        to='/'
        className='bg-background/90 focus-visible:outline-ring absolute top-6 left-6 z-10 flex items-center gap-2 rounded-xl p-2.5 transition-opacity hover:opacity-80 focus-visible:outline-2 focus-visible:outline-offset-4 sm:top-8 sm:left-8'
      >
        <div className='relative h-8 w-8'>
          {loading ? (
            <Skeleton className='absolute inset-0 rounded-full' />
          ) : (
            <img
              src={logo}
              alt={t('Logo')}
              className='h-8 w-8 object-contain'
            />
          )}
        </div>
        {loading ? (
          <Skeleton className='h-6 w-24' />
        ) : (
          <h1 className='text-xl font-medium'>{systemName}</h1>
        )}
      </Link>
      <div className='flex min-w-0 items-center justify-center px-4 pt-28 pb-10 sm:px-8 lg:py-16'>
        <div className='w-full max-w-[440px] space-y-2'>{props.children}</div>
      </div>
    </div>
  )
}
