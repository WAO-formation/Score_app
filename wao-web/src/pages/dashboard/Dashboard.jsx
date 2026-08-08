import { Trophy, Users, Zap, CheckCircle, Calendar, MapPin, ArrowRight, Radio } from "lucide-react";
import React, { useState } from "react";
import { recentTeams, teamsData } from "../../config/constants";
import { useGames } from "../../context/GamesContext";
import { useNavigate } from "react-router-dom";
import CreateGame from "../games/components/CreateGame";
import CreateTeam from "../../components/CreateTeam";
import { BRAND } from "../../config/brand";

function Dashboard() {
  const { games, addGame } = useGames();
  const navigate = useNavigate();
  const [showCreateGameModal, setShowCreateGameModal] = useState(false);
  const [showCreateTeamModal, setShowCreateTeamModal] = useState(false);

  const upcomingGames = games.filter((g) => g.status === "upcoming");
  const liveGames = games.filter((g) => g.status === "live");
  const completedGames = games.filter((g) => g.status === "completed");

  return (
    <section className="scrollbar-hide px-2 py-4 md:p-4 pb-12 space-y-5">

      {/* ── Hero Banner ── */}
      <div className="relative bg-gradient-to-br from-[#011B3B] via-[#022d5f] to-[#011B3B] rounded-2xl overflow-hidden p-5 md:p-8">
        <div className="absolute -right-16 -top-16 opacity-10 pointer-events-none">
          <img src="/assets/design/wao-ball.png" alt="" className="w-64 h-64 object-contain" />
        </div>
        <div className="absolute -left-10 -bottom-10 opacity-5 pointer-events-none">
          <img src="/assets/design/wao-ball.png" alt="" className="w-48 h-48 object-contain" />
        </div>

        <div className="relative z-10 flex flex-col md:flex-row md:items-center md:justify-between gap-6">
          <div>
            <p className="text-white/60 text-sm mb-1" style={{ fontFamily: BRAND.font.body }}>Welcome back 👋</p>
            <h1 className="text-2xl md:text-4xl text-white mb-2" style={{ fontFamily: BRAND.font.heading }}>WAO Dashboard</h1>
            <p className="text-white/70 text-sm max-w-md" style={{ fontFamily: BRAND.font.body }}>Manage your games, teams and track live scores all in one place.</p>
          </div>

          {/* Hero Stats */}
          <div className="flex gap-3 flex-wrap">
            {[
              { label: "Total Teams", value: teamsData.length, color: "bg-white/10" },
              { label: "Live Now", value: liveGames.length, color: "bg-[#D30336]/80" },
              { label: "Upcoming", value: upcomingGames.length, color: "bg-white/10" },
            ].map((s) => (
              <div key={s.label} className={`${s.color} backdrop-blur-sm rounded-xl px-4 py-3 text-center min-w-[80px]`}>
                <p className="text-2xl font-bold text-white" style={{ fontFamily: BRAND.font.heading }}>{s.value}</p>
                <p className="text-white/70 text-xs mt-0.5" style={{ fontFamily: BRAND.font.body }}>{s.label}</p>
              </div>
            ))}
          </div>
        </div>

        {/* CTA Buttons */}
        <div className="relative z-10 flex gap-2 mt-5">
          <button
            onClick={() => setShowCreateTeamModal(true)}
            className="flex items-center gap-1.5 px-4 py-2 bg-white text-[#011B3B] font-semibold text-sm hover:shadow-lg transition-all"
            style={{ fontFamily: BRAND.font.body }}
          >
            <Users className="w-4 h-4" /> Create Team
          </button>
          <button
            onClick={() => setShowCreateGameModal(true)}
            className="flex items-center gap-1.5 px-4 py-2 bg-[#c81434] text-white font-semibold text-sm hover:bg-[#e21e43] transition-all"
            style={{ fontFamily: BRAND.font.body }}
          >
            <Trophy className="w-4 h-4" /> Create Game
          </button>
        </div>
      </div>


      <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">

        {/* ── Left: Live Spotlight + Upcoming ── */}
        <div className="lg:col-span-2 space-y-5">

          {/* Live Game Spotlight */}
          {liveGames.length > 0 ? (
            <div className="bg-gradient-to-br from-[#0d3d3d] to-[#0a5252] p-5 border border-teal-700/30">
              <div className="flex items-center gap-2 mb-4">
                <span className="flex items-center gap-1.5 bg-emerald-500 text-white text-xs font-bold px-3 py-1" style={{ fontFamily: BRAND.font.body }}>
                  <span className="w-1.5 h-1.5 bg-white rounded-full animate-pulse" /> LIVE
                </span>
                <span className="text-white/50 text-xs">Game in progress</span>
              </div>
              {liveGames.map((game) => (
                <div key={game.id}>
                  <div className="flex items-center justify-between gap-4">
                    {/* Home */}
                    <div className="flex flex-col items-center flex-1">
                      <div className="w-16 h-16 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center shadow-lg mb-2">
                        <span className="text-white font-bold">{game.homeTeam.substring(0, 2).toUpperCase()}</span>
                      </div>
                      <p className="text-white text-sm font-semibold text-center line-clamp-1">{game.homeTeam}</p>
                    </div>

                    {/* Score */}
                    <div className="flex flex-col items-center">
                      <div className="flex items-center gap-3 bg-white/10 rounded-xl px-5 py-3">
                        <span className="text-4xl font-bold text-white">{game.homeScore}</span>
                        <span className="text-white/40 text-xl">:</span>
                        <span className="text-4xl font-bold text-white">{game.awayScore}</span>
                      </div>
                      <p className="text-emerald-300 text-xs font-semibold mt-2" style={{ fontFamily: BRAND.font.body }}>{game.currentQuarter} · {game.timeRemaining}</p>
                    </div>

                    {/* Away */}
                    <div className="flex flex-col items-center flex-1">
                      <div className="w-16 h-16 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center shadow-lg mb-2">
                        <span className="text-white font-bold">{game.awayTeam.substring(0, 2).toUpperCase()}</span>
                      </div>
                      <p className="text-white text-sm font-semibold text-center line-clamp-1">{game.awayTeam}</p>
                    </div>
                  </div>

                  <div className="flex items-center justify-between mt-4 pt-4 border-t border-white/10 text-xs text-white/50">
                    <span className="flex items-center gap-1"><MapPin className="w-3 h-3" />{game.venue}</span>
                    <button
                      onClick={() => navigate(`/games/${game.id}`)}
                      className="flex items-center gap-1 text-[#D30336] font-semibold hover:text-[#ff3355] transition-colors"
                    >
                      Watch Live <ArrowRight className="w-3 h-3" />
                    </button>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <div className="bg-gradient-to-br from-[#0d3d3d] to-[#0a5252] p-8 border border-teal-700/20 flex flex-col items-center justify-center text-center">
              <div className="w-14 h-14 bg-[#D30336]/20 rounded-full flex items-center justify-center mb-3">
                <Radio className="w-7 h-7 text-[#D30336]" />
              </div>
              <p className="text-white font-semibold mb-1">No Live Games</p>
              <p className="text-white/40 text-sm">Games in progress will appear here</p>
            </div>
          )}

          {/* Upcoming Games */}
          <div className="bg-white rounded-2xl shadow-sm p-4 md:p-5">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-[#011B3B] text-base uppercase tracking-widest" style={{ fontFamily: BRAND.font.heading }}>Upcoming Games</h3>
              <button onClick={() => navigate('/games')} className="text-[#c81434] text-xs font-semibold flex items-center gap-1 hover:underline" style={{ fontFamily: BRAND.font.body }}>
                View all <ArrowRight className="w-3 h-3" />
              </button>
            </div>
            {upcomingGames.length > 0 ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                {upcomingGames.map((game) => (
                  <div key={game.id} className="bg-gray-50 rounded-xl p-4 border border-gray-100">
                    <div className="flex items-center justify-between mb-3">
                      <span className="text-xs text-gray-400 font-medium uppercase tracking-wide">{game.championship}</span>
                      <span className="text-xs bg-blue-100 text-blue-700 font-semibold px-2 py-0.5 rounded-full">Upcoming</span>
                    </div>
                    <div className="flex items-center justify-between gap-2">
                      <div className="flex flex-col items-center flex-1">
                        <div className="w-10 h-10 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center mb-1">
                          <span className="text-white font-bold text-xs">{game.homeTeam.substring(0, 2).toUpperCase()}</span>
                        </div>
                        <p className="text-xs font-semibold text-[#011B3B] text-center line-clamp-1">{game.homeTeam}</p>
                      </div>
                      <div className="text-center">
                        <div className="bg-[#011B3B] text-white text-xs font-bold px-3 py-1.5 rounded-lg">VS</div>
                        <p className="text-[#FFC600] text-xs font-semibold mt-1">{game.time}</p>
                      </div>
                      <div className="flex flex-col items-center flex-1">
                        <div className="w-10 h-10 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center mb-1">
                          <span className="text-white font-bold text-xs">{game.awayTeam.substring(0, 2).toUpperCase()}</span>
                        </div>
                        <p className="text-xs font-semibold text-[#011B3B] text-center line-clamp-1">{game.awayTeam}</p>
                      </div>
                    </div>
                    <div className="flex items-center gap-1 mt-3 text-xs text-gray-400">
                      <MapPin className="w-3 h-3" />{game.venue}
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-8 text-gray-400">
                <Calendar className="w-10 h-10 mx-auto mb-2 opacity-40" />
                <p className="text-sm">No upcoming games scheduled</p>
              </div>
            )}
          </div>
        </div>

        {/* ── Right Sidebar ── */}
        <div className="space-y-5">

          {/* Completed Games */}
          <div className="bg-white rounded-2xl shadow-sm p-4">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-[#011B3B] text-base uppercase tracking-widest" style={{ fontFamily: BRAND.font.heading }}>Recent Results</h3>
              <CheckCircle className="w-4 h-4 text-green-500" />
            </div>
            {completedGames.length > 0 ? (
              <div className="space-y-3">
                {completedGames.map((game) => (
                  <div key={game.id} className="flex items-center justify-between bg-gray-50 rounded-xl px-3 py-2.5 cursor-pointer hover:bg-gray-100 transition-colors" onClick={() => navigate(`/games/${game.id}`)}>
                    <div className="flex items-center gap-2 min-w-0">
                      <div className="w-8 h-8 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center flex-shrink-0">
                        <span className="text-white font-bold text-xs">{game.homeTeam.substring(0, 2).toUpperCase()}</span>
                      </div>
                      <div className="min-w-0">
                        <p className="text-xs font-semibold text-[#011B3B] truncate">{game.homeTeam}</p>
                        <p className="text-xs text-gray-400 truncate">vs {game.awayTeam}</p>
                      </div>
                    </div>
                    <div className="flex items-center gap-1.5 flex-shrink-0">
                      <span className="text-sm font-bold text-[#011B3B]">{game.homeScore} - {game.awayScore}</span>
                      <span className="text-xs bg-green-100 text-green-700 font-semibold px-1.5 py-0.5 rounded-full">FT</span>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-sm text-gray-400 text-center py-4">No completed games yet</p>
            )}
          </div>

          {/* Teams */}
          <div className="bg-white rounded-2xl shadow-sm p-4">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-[#011B3B] text-base uppercase tracking-widest" style={{ fontFamily: BRAND.font.heading }}>Teams</h3>
              <button onClick={() => navigate('/teams')} className="text-[#c81434] text-xs font-semibold flex items-center gap-1 hover:underline" style={{ fontFamily: BRAND.font.body }}>
                View all <ArrowRight className="w-3 h-3" />
              </button>
            </div>
            <div className="space-y-2">
              {recentTeams.map((team) => (
                <div key={team.id} className="flex items-center justify-between p-2.5 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors cursor-pointer">
                  <div className="flex items-center gap-2.5">
                    <div className="w-9 h-9 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center flex-shrink-0">
                      <span className="text-white font-bold text-xs">{team.name.substring(0, 2).toUpperCase()}</span>
                    </div>
                    <div>
                      <p className="font-semibold text-[#011B3B] text-sm">{team.name}</p>
                      <p className="text-xs text-gray-400">{team.members} members</p>
                    </div>
                  </div>
                  <span className={`text-xs font-semibold px-2 py-0.5 rounded-full ${team.status === 'Active' ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-500'}`}>
                    {team.status}
                  </span>
                </div>
              ))}
            </div>
          </div>

          {/* Quick Actions */}
          <div className="bg-gradient-to-br from-[#011B3B] to-[#022d5f] rounded-2xl p-4">
            <h3 className="text-white text-base mb-3 uppercase tracking-widest" style={{ fontFamily: BRAND.font.heading }}>Quick Actions</h3>
            <div className="space-y-2">
              {[
                { label: "Schedule a Game", icon: Calendar, action: () => setShowCreateGameModal(true) },
                { label: "Add a Team", icon: Users, action: () => setShowCreateTeamModal(true) },
                { label: "View All Games", icon: Trophy, action: () => navigate('/games') },
              ].map(({ label, icon: Icon, action }) => (
                <button key={label} onClick={action} className="w-full flex items-center gap-3 bg-white/10 hover:bg-white/20 text-white text-sm font-medium px-3 py-2.5 transition-colors text-left" style={{ fontFamily: BRAND.font.body }}>
                  <Icon className="w-4 h-4 text-white/70" /> {label}
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>

      <CreateGame isOpen={showCreateGameModal} onClose={() => setShowCreateGameModal(false)} onCreateGame={(g) => { addGame(g); setShowCreateGameModal(false); }} />
      <CreateTeam isOpen={showCreateTeamModal} onClose={() => setShowCreateTeamModal(false)} onCreateTeam={() => {}} />
    </section>
  );
}

export default Dashboard;
