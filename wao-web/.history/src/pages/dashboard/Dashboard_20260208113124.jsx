import React from 'react'

function Dashboard() {
  return (
    <section className='flex flex-col lg:flex-row gap-4 h-full'>
        {/* this will cover the main container */}
        <div className="flex-1 lg:w-[75%] overflow-y-auto spacer-y-6 pr-0 scrollbar-hide ">

            {/* this is the welcome section  */}
            <div className="bg-white rounded-xl shadow-sm p-6">
                <h1 className="text-2xl font-bold text-[#011B3B] mb-2">
            Welcome back, Afanyu!
          </h1>
          <p className="text-gray-600">
            Here's what's happening with your sports management today.
          </p>
            </div>
        </div>

        {/* this is a mini section  */}
        <aside className='w-full lg:w-[25%] overflow-y-auto space-y-6 pl-0 lg:pl-2 scrollbar-hide'></aside>
    </section>
  )
}

export default Dashboard