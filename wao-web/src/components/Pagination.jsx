import { ChevronLeft, ChevronRight } from 'lucide-react';
import { BRAND } from '../config/brand';

const B = BRAND.font.body;

export const PAGE_SIZE = 10;

export function paginate(items, page) {
  const start = (page - 1) * PAGE_SIZE;
  return items.slice(start, start + PAGE_SIZE);
}

export default function Pagination({ total, page, onChange }) {
  const totalPages = Math.ceil(total / PAGE_SIZE);
  if (totalPages <= 1) return null;

  const start = (page - 1) * PAGE_SIZE + 1;
  const end   = Math.min(page * PAGE_SIZE, total);

  return (
    <div className="flex items-center justify-between pt-4 border-t border-gray-100 mt-4">
      <span className="text-xs text-gray-400" style={{ fontFamily: B }}>
        {start}–{end} of {total}
      </span>
      <div className="flex items-center gap-1">
        <button
          onClick={() => onChange(page - 1)}
          disabled={page === 1}
          className="p-1.5 rounded hover:bg-gray-100 disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
        >
          <ChevronLeft className="w-4 h-4 text-[#011B3B]" />
        </button>
        {Array.from({ length: totalPages }, (_, i) => i + 1).map(p => (
          <button
            key={p}
            onClick={() => onChange(p)}
            className={`w-7 h-7 text-xs font-semibold rounded transition-colors ${
              p === page ? 'bg-[#011B3B] text-white' : 'text-gray-500 hover:bg-gray-100'
            }`}
            style={{ fontFamily: B }}
          >
            {p}
          </button>
        ))}
        <button
          onClick={() => onChange(page + 1)}
          disabled={page === totalPages}
          className="p-1.5 rounded hover:bg-gray-100 disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
        >
          <ChevronRight className="w-4 h-4 text-[#011B3B]" />
        </button>
      </div>
    </div>
  );
}
