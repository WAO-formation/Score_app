import { Trophy, Users, Zap, CheckCircle, Calendar, MapPin, ArrowRight, Radio } from "lucide-react";
import React, { useState, useEffect } from "react";
import { subscribeToTeams } from "../../services/teamsService";
import { isPastDue } from "../../services/matchesService";
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
  const [teams, setTeams] = useState([]);

  useEffect(() => subscribeToTeams(setTeams, () => setTeams([])), []);

  const upcomingGames = games.filter((g) => g.status === "upcoming" && !isPastDue(g));
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
              { label: "Total Teams", value: teams.length, color: "bg-white/10" },
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
            <div className="bg-white border border-gray-100 p-5">
              <div className="flex items-center gap-2 mb-5">
                <span className="flex items-center gap-1.5 bg-emerald-500 text-white text-xs font-bold px-3 py-1" style={{ fontFamily: BRAND.font.body }}>
                  <span className="w-1.5 h-1.5 bg-white rounded-full animate-pulse" /> LIVE
                </span>
                <span className="text-gray-400 text-xs" style={{ fontFamily: BRAND.font.body }}>Game in progress</span>
              </div>

              {liveGames.map((game) => (
                <div key={game.id}>
                  <div className="flex items-center justify-between gap-4">

                    {/* Home */}
                    <div className="flex flex-col items-center flex-1 gap-1.5">
                      <div className="w-14 h-14 bg-amber-400 flex items-center justify-center">
                        <span className="text-white font-medium text-sm" style={{ fontFamily: BRAND.font.heading }}>{game.homeTeam.substring(0, 2).toUpperCase()}</span>
                      </div>
                      <p className="text-[#011B3B] text-xs font-medium text-center line-clamp-1" style={{ fontFamily: BRAND.font.body }}>{game.homeTeam}</p>
                      <span className="text-3xl text-[#011B3B]" style={{ fontFamily: BRAND.font.heading }}>{game.homeScore}</span>
                    </div>

                    {/* Middle — time */}
                    <div className="flex flex-col items-center gap-2">
                      <div className="flex flex-col items-center bg-emerald-50 border border-emerald-200 px-5 py-3 gap-1">
                        <span className="text-emerald-600 text-[10px] font-bold uppercase tracking-widest" style={{ fontFamily: BRAND.font.body }}>Q{game.currentQuarter}</span>
                        <span className="text-emerald-700 text-xl font-bold tabular-nums" style={{ fontFamily: BRAND.font.heading }}>{game.timeRemaining}</span>
                      </div>
                    </div>

                    {/* Away */}
                    <div className="flex flex-col items-center flex-1 gap-1.5">
                      <div className="w-14 h-14 bg-[#c81434] flex items-center justify-center">
                        <span className="text-white font-medium text-sm" style={{ fontFamily: BRAND.font.heading }}>{game.awayTeam.substring(0, 2).toUpperCase()}</span>
                      </div>
                      <p className="text-[#011B3B] text-xs font-medium text-center line-clamp-1" style={{ fontFamily: BRAND.font.body }}>{game.awayTeam}</p>
                      <span className="text-3xl text-[#011B3B]" style={{ fontFamily: BRAND.font.heading }}>{game.awayScore}</span>
                    </div>
                  </div>

                  <div className="flex items-center justify-between mt-4 pt-4 border-t border-gray-100 text-xs text-gray-400" style={{ fontFamily: BRAND.font.body }}>
                    <span className="flex items-center gap-1"><MapPin className="w-3 h-3" />{game.venue}</span>
                    <button
                      onClick={() => navigate(`/games/${game.id}`)}
                      className="flex items-center gap-1 text-emerald-600 font-semibold hover:text-emerald-500 transition-colors"
                    >
                      Watch Live <ArrowRight className="w-3 h-3" />
                    </button>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <div className="bg-white border border-gray-100 p-8 flex flex-col items-center justify-center text-center">
              <div className="w-14 h-14 bg-gray-50 flex items-center justify-center mb-3">
                <Radio className="w-7 h-7 text-gray-300" />
              </div>
              <p className="text-[#011B3B] font-medium mb-1" style={{ fontFamily: BRAND.font.body }}>No Live Games</p>
              <p className="text-gray-400 text-sm" style={{ fontFamily: BRAND.font.body }}>Games in progress will appear here</p>
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
            {teams.length > 0 ? (
              <div className="space-y-2">
                {teams.slice(0, 4).map((team) => {
                  const memberCount = Object.values(team.roster).flat().length;
                  return (
                    <div key={team.id} className="flex items-center justify-between p-2.5 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors cursor-pointer" onClick={() => navigate(`/teams/${team.id}`)}>
                      <div className="flex items-center gap-2.5">
                        <div className="w-9 h-9 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center flex-shrink-0">
                          <span className="text-white font-bold text-xs">{team.name.substring(0, 2).toUpperCase()}</span>
                        </div>
                        <div>
                          <p className="font-semibold text-[#011B3B] text-sm">{team.name}</p>
                          <p className="text-xs text-gray-400">{memberCount} {memberCount === 1 ? 'member' : 'members'}</p>
                        </div>
                      </div>
                      <span className="text-xs font-semibold px-2 py-0.5 rounded-full bg-blue-100 text-blue-700">
                        {team.category}
                      </span>
                    </div>
                  );
                })}
              </div>
            ) : (
              <p className="text-sm text-gray-400 text-center py-4">No teams yet</p>
            )}
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
